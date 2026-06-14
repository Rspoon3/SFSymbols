import Foundation

/// Shared helpers for the generator CLI (`sfsym-gen`).
///
/// For now the generator orchestrates the existing repo-root scripts
/// (`UpdateScript.swift`, `ParseSwiftUIDoc.swift`, `ParseUIKitDoc.swift`). The
/// intent is to incrementally port that logic into this module so generation and
/// querying share one model layer.

public enum GenError: Error, CustomStringConvertible {
    case missing(String)
    case scriptFailed(script: String, code: Int32)

    public var description: String {
        switch self {
        case .missing(let message): return message
        case .scriptFailed(let script, let code): return "\(script) failed with exit code \(code)."
        }
    }
}

public enum SymbolsApp {
    /// Known install locations, beta first.
    public static let candidates = [
        "/Applications/SF Symbols Beta.app",
        "/Applications/SF Symbols.app",
    ]

    /// First SF Symbols app that exists on disk, if any.
    public static func locate() -> String? {
        candidates.first { FileManager.default.fileExists(atPath: $0) }
    }
}

/// Runs a top-level `swift <script> <args>` with inherited stdio, throwing on failure.
public func runSwiftScript(at scriptPath: String, arguments: [String], workingDirectory: URL) throws {
    guard FileManager.default.fileExists(atPath: scriptPath) else {
        throw GenError.missing("Script not found: \(scriptPath)")
    }

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    process.arguments = [scriptPath] + arguments
    process.currentDirectoryURL = workingDirectory
    process.standardInput = FileHandle.standardInput
    process.standardOutput = FileHandle.standardOutput
    process.standardError = FileHandle.standardError

    try process.run()
    process.waitUntilExit()

    guard process.terminationStatus == 0 else {
        throw GenError.scriptFailed(script: (scriptPath as NSString).lastPathComponent, code: process.terminationStatus)
    }
}
