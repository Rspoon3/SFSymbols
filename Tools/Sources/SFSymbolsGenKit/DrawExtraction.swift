import Foundation

//  DrawExtraction.swift
//
//  Automatically extracts the SF Symbols "Draw" category — the one piece of
//  metadata that lives in NO readable file. Draw membership is computed by the
//  app at render time: it composes each symbol's annotation (merging slash/badge/
//  base layers) and calls the private getter
//  `SFSymbolsShared.UnifiedSymbolAnnotation.hasDrawInfo`. That computation needs
//  the app's live symbol store, so we drive the app's own code:
//
//    1. Decrypt the font's `symp` table → every symbol's PUA scalar (Decrypt.swift).
//    2. Locate the app's draw-check closure — the SOLE caller of `hasDrawInfo`.
//    3. Clone the app and re-sign it ad-hoc with `get-task-allow` so it's debuggable.
//    4. Launch it under lldb; on the first render, capture the live symbol-store
//       context, then call the draw-check function directly for every PUA scalar.
//    5. Map draw-flagged scalars back to names → write `draw.txt`.
//
//  This replaces a manual "open the app, select Draw, ⌘A, ⌘C" clipboard step.
//  It SOFT-FAILS: any problem returns false and the caller falls back to the
//  manual prompt. See `.claude/skills/update-sf-symbols/SKILL.md` for the operational
//  notes (including how to re-derive the draw-check function address after an app update).

// MARK: - Public entry points

/// Standalone Draw-category extraction (used by the `sfsym-gen draw` subcommand and
/// for debugging). Writes the draw symbol names to `outputPath`. Returns `true` on
/// success. Uses a temporary working directory that is cleaned up afterward.
@discardableResult
public func extractDrawCategory(appPath: String, outputPath: URL, drawFunc: UInt64? = nil) -> Bool {
    let workingDir = FileManager.default.temporaryDirectory
        .appendingPathComponent("sfsym-draw-\(ProcessInfo.processInfo.processIdentifier)", isDirectory: true)
    try? FileManager.default.removeItem(at: workingDir)
    try? FileManager.default.createDirectory(at: workingDir, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: workingDir) }
    return extractDrawCategoryAutomatically(
        appPath: appPath,
        drawFilePath: outputPath,
        drawFuncOverride: drawFunc,
        workingDir: workingDir
    )
}

// MARK: - Internal entry point

/// Extracts the Draw category by driving the app's own `hasDrawInfo` logic and
/// writes the matching symbol names to `drawFilePath`. Returns `true` on success.
///
/// - Parameter drawFuncOverride: file address (vm address, e.g. `0x1000ec6bc`) of
///   the draw-check closure, if auto-detection needs to be bypassed for a new app
///   build. When nil, the address is located automatically.
func extractDrawCategoryAutomatically(
    appPath: String,
    drawFilePath: URL,
    drawFuncOverride: UInt64?,
    workingDir: URL
) -> Bool {
    guard isCommandAvailable("lldb"), isCommandAvailable("codesign"), isCommandAvailable("otool") else {
        print("⚠️  Draw auto-extraction needs lldb/codesign/otool (Xcode CLT). Falling back to manual capture.")
        return false
    }

    // 1. Symbol scalars (name ↔ PUA) from the decrypted font table.
    guard let puaToNames = loadSympPUAToNames(appPath: appPath) else {
        print("⚠️  Could not read the font 'symp' table for Draw extraction. Falling back to manual capture.")
        return false
    }
    let scalars: [UInt32] = puaToNames.keys.compactMap { UInt32($0, radix: 16) }.sorted()
    guard !scalars.isEmpty else { return false }

    guard let exeName = bundleExecutableName(appPath: appPath) else {
        print("⚠️  Could not read the app's executable name. Falling back to manual capture.")
        return false
    }
    let appExe = URL(fileURLWithPath: appPath).appendingPathComponent("Contents/MacOS/\(exeName)").path

    // 2. Locate the draw-check closure (sole hasDrawInfo caller).
    guard let drawFunc = drawFuncOverride ?? locateDrawCheckFunction(appExe: appExe) else {
        print("⚠️  Could not locate the draw-check function in the app binary (it may have moved in this build). Pass --draw-func 0x… or fall back to manual capture.")
        return false
    }
    print(String(format: "🔎 Draw-check function at 0x%llx", drawFunc))

    // 3. Clone + re-sign a debuggable copy.
    guard let copyExe = makeDebuggableCopy(appPath: appPath, exeName: exeName, workingDir: workingDir) else {
        print("⚠️  Could not create a debuggable app copy. Falling back to manual capture.")
        return false
    }
    defer { try? FileManager.default.removeItem(at: URL(fileURLWithPath: copyExe).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()) }

    // 4. Drive the app under lldb to evaluate every scalar, with a live progress bar.
    let outURL = workingDir.appendingPathComponent("draw_out.tsv")
    guard runLLDBExtraction(copyExe: copyExe, drawFunc: drawFunc, scalars: scalars, outURL: outURL, workingDir: workingDir) else {
        print("⚠️  lldb Draw extraction did not complete. Falling back to manual capture.")
        return false
    }

    // 5. Map draw-flagged scalars → names → draw.txt.
    guard let results = try? String(contentsOf: outURL, encoding: .utf8) else { return false }
    var drawNames = Set<String>()
    for line in results.split(separator: "\n") {
        let parts = line.split(separator: "\t")
        guard parts.count == 2, parts[1] == "1" else { continue }
        let hex = String(parts[0]).uppercased()
        if let names = puaToNames[hex] { drawNames.formUnion(names) }
    }
    guard !drawNames.isEmpty else {
        print("⚠️  Draw extraction produced no symbols. Falling back to manual capture.")
        return false
    }

    do {
        try drawNames.sorted().joined(separator: "\n").write(to: drawFilePath, atomically: true, encoding: .utf8)
        print("☑️  Auto-extracted Draw category: \(drawNames.count) symbols → draw.txt")
        return true
    } catch {
        print("⚠️  Could not write draw.txt: \(error). Falling back to manual capture.")
        return false
    }
}

// MARK: - Step 2: locate the draw-check closure

/// The draw-check closure is the SOLE function that calls
/// `UnifiedSymbolAnnotation.hasDrawInfo`. We find that `bl` in the app's
/// disassembly, then walk backward to the enclosing function's prologue (the
/// instruction right after the previous function's terminator).
private func locateDrawCheckFunction(appExe: String) -> UInt64? {
    guard let disasm = runProcess("/usr/bin/otool", ["-arch", "arm64", "-tV", appExe])?.stdout else { return nil }

    // Parse "<hexaddr>\t<mnemonic> …" lines into (address, isTerminator, isCall-to-hasDrawInfo).
    var addrs: [UInt64] = []
    var isBoundary: [Bool] = []   // ret / brk → end of a function
    var callIndex = -1
    addrs.reserveCapacity(1 << 20); isBoundary.reserveCapacity(1 << 20)

    disasm.enumerateLines { line, _ in
        guard let tab = line.firstIndex(of: "\t") else { return }
        let addrStr = line[line.startIndex..<tab]
        guard let addr = UInt64(addrStr, radix: 16) else { return }
        let rest = line[line.index(after: tab)...]
        let i = addrs.count
        addrs.append(addr)
        isBoundary.append(rest.hasPrefix("ret") || rest.hasPrefix("brk"))
        if callIndex < 0, rest.contains("hasDrawInfoSbvg"), rest.contains("bl") {
            callIndex = i
        }
    }
    guard callIndex >= 0 else { return nil }

    // Walk back to the previous function boundary; the entry is the next instruction.
    var j = callIndex - 1
    while j > 0, !isBoundary[j] { j -= 1 }
    let entryIndex = isBoundary[j] ? j + 1 : 0
    return addrs[entryIndex]
}

// MARK: - Step 3: debuggable copy

/// Clones the app (APFS copy-on-write, near-instant) into `workingDir` and re-signs
/// the main executable ad-hoc with `get-task-allow` so lldb can drive it.
/// Returns the path to the copied main executable.
private func makeDebuggableCopy(appPath: String, exeName: String, workingDir: URL) -> String? {
    let destApp = workingDir.appendingPathComponent("SFSymbolsDraw.app")
    try? FileManager.default.removeItem(at: destApp)
    guard runProcess("/bin/cp", ["-R", appPath, destApp.path])?.status == 0 else { return nil }

    let ent = workingDir.appendingPathComponent("get-task-allow.plist")
    let entXML = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0"><dict><key>com.apple.security.get-task-allow</key><true/></dict></plist>
    """
    guard (try? entXML.write(to: ent, atomically: true, encoding: .utf8)) != nil else { return nil }

    let copyExe = destApp.appendingPathComponent("Contents/MacOS/\(exeName)").path
    let sign = runProcess("/usr/bin/codesign", ["--force", "--sign", "-", "--entitlements", ent.path, copyExe])
    guard sign?.status == 0 else { return nil }
    return copyExe
}

// MARK: - Step 4: drive lldb with a progress bar

private func runLLDBExtraction(copyExe: String, drawFunc: UInt64, scalars: [UInt32], outURL: URL, workingDir: URL) -> Bool {
    let inURL = workingDir.appendingPathComponent("draw_in_scalars.txt")
    let pyURL = workingDir.appendingPathComponent("extract_draw.py")
    let driveURL = workingDir.appendingPathComponent("drive_extract.lldb")
    try? scalars.map { String($0, radix: 16).uppercased() }.joined(separator: "\n").write(to: inURL, atomically: true, encoding: .utf8)
    try? FileManager.default.removeItem(at: outURL)
    guard (try? lldbExtractorPython.write(to: pyURL, atomically: true, encoding: .utf8)) != nil else { return false }

    let drive = """
    command script import \(shQuote(pyURL.path))
    process launch --stop-at-entry
    command script add -f extract_draw.setup draw_setup
    draw_setup
    continue
    """
    guard (try? drive.write(to: driveURL, atomically: true, encoding: .utf8)) != nil else { return false }

    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: "/usr/bin/lldb")
    proc.arguments = ["-b", "-s", driveURL.path, copyExe]
    var env = ProcessInfo.processInfo.environment
    env["DRAW_FUNC"] = String(format: "0x%llx", drawFunc)
    env["DRAW_IN"] = inURL.path
    env["DRAW_OUT"] = outURL.path
    proc.environment = env
    proc.standardOutput = FileHandle.nullDevice
    proc.standardError = FileHandle.nullDevice

    do { try proc.run() } catch { return false }

    // Poll the incremental output for a live progress bar (the app appears frozen
    // while lldb drives it — that's expected; the copy is killed when done).
    let total = scalars.count
    let deadline = Date().addingTimeInterval(600) // 10-minute safety timeout
    print("⏳ Driving the app under lldb to evaluate \(total) symbols…")
    while proc.isRunning {
        if Date() > deadline { proc.terminate(); break }
        let done = lineCount(of: outURL)
        printProgress(done: done, total: total)
        Thread.sleep(forTimeInterval: 0.4)
    }
    proc.waitUntilExit()
    printProgress(done: lineCount(of: outURL), total: total)
    print("")  // end the progress line

    // Success if we evaluated (close to) every scalar.
    return lineCount(of: outURL) >= total
}

/// The lldb Python harness. On the first natural breakpoint hit it captures the
/// live symbol-store context, disables the breakpoint (stopping the render churn),
/// then calls the draw-check function directly for every input scalar — fabricating
/// each element from a real one (only the leading 4-byte scalar differs).
private let lldbExtractorPython = """
import lldb, os
DRAW_FUNC = int(os.environ.get("DRAW_FUNC", "0"), 16)
IN  = os.environ["DRAW_IN"]
OUT = os.environ["DRAW_OUT"]
_done = {"v": False}

def on_hit(frame, bp_loc, d):
    if _done["v"]:
        return False
    _done["v"] = True
    process = frame.GetThread().GetProcess(); target = process.GetTarget()
    err = lldb.SBError()
    ctx  = frame.FindRegister("x1").GetValueAsUnsigned()
    el0  = frame.FindRegister("x0").GetValueAsUnsigned()
    tail = process.ReadMemory(el0 + 4, 16, err)
    scratch = process.AllocateMemory(32, 3, err)
    func = target.ResolveFileAddress(DRAW_FUNC).GetLoadAddress(target)
    bp_loc.GetBreakpoint().SetEnabled(False)
    opts = lldb.SBExpressionOptions(); opts.SetIgnoreBreakpoints(True); opts.SetTimeoutInMicroSeconds(3000000)
    scalars = [int(x, 16) for x in open(IN) if x.strip()]
    out = open(OUT, "w")
    for s in scalars:
        process.WriteMemory(scratch, s.to_bytes(4, "little") + tail, err)
        expr = "(unsigned int)((unsigned char(*)(void*,void*))%d)((void*)%d,(void*)%d)" % (func, scratch, ctx)
        v = frame.EvaluateExpression(expr, opts)
        out.write("%X\\t%d\\n" % (s, v.GetValueAsUnsigned() & 1)); out.flush()
    out.close()
    process.Kill()   # let `lldb -b` exit
    return False

def setup(debugger, command, result, internal_dict):
    t = debugger.GetSelectedTarget()
    bp = t.BreakpointCreateBySBAddress(t.ResolveFileAddress(DRAW_FUNC))
    bp.SetScriptCallbackFunction("extract_draw.on_hit")
"""

// MARK: - Small helpers

private func bundleExecutableName(appPath: String) -> String? {
    let info = URL(fileURLWithPath: appPath).appendingPathComponent("Contents/Info.plist")
    guard let data = try? Data(contentsOf: info),
          let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
          let exe = plist["CFBundleExecutable"] as? String else { return nil }
    return exe
}

private func isCommandAvailable(_ name: String) -> Bool {
    runProcess("/usr/bin/which", [name])?.status == 0
}

private func runProcess(_ launchPath: String, _ args: [String]) -> (status: Int32, stdout: String)? {
    let proc = Process()
    proc.executableURL = URL(fileURLWithPath: launchPath)
    proc.arguments = args
    let pipe = Pipe()
    proc.standardOutput = pipe
    proc.standardError = FileHandle.nullDevice
    do { try proc.run() } catch { return nil }
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    proc.waitUntilExit()
    return (proc.terminationStatus, String(data: data, encoding: .utf8) ?? "")
}

private func lineCount(of url: URL) -> Int {
    guard let s = try? String(contentsOf: url, encoding: .utf8), !s.isEmpty else { return 0 }
    return s.reduce(0) { $1 == "\n" ? $0 + 1 : $0 }
}

private func printProgress(done: Int, total: Int) {
    let width = 30
    let frac = total > 0 ? min(1.0, Double(done) / Double(total)) : 0
    let filled = Int(frac * Double(width))
    let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: width - filled)
    let pct = Int(frac * 100)
    print("\r   [\(bar)] \(pct)%  \(done)/\(total)", terminator: "")
    fflush(stdout)
}

private func shQuote(_ s: String) -> String { "\"\(s.replacingOccurrences(of: "\"", with: "\\\""))\"" }
