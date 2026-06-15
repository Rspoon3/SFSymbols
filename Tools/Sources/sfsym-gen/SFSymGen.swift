import ArgumentParser
import Foundation
import SFSymbolsGenKit

@main
struct SFSymGen: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sfsym-gen",
        abstract: "Regenerate the SFSymbols library sources from the SF Symbols app.",
        discussion: """
        Maintainer tooling. Runs symbol generation in-process; \
        run it from the repository root (or pass --repo-root).
        """,
        version: "0.1.0",
        subcommands: [Update.self, Wrappers.self, Draw.self]
    )
}

/// Shared `--repo-root` option (defaults to the current directory).
struct RepoRoot: ParsableArguments {
    @Option(name: .customLong("repo-root"), help: "Path to the SFSymbols repository root.")
    var path: String = FileManager.default.currentDirectoryPath

    var url: URL { URL(fileURLWithPath: path) }
}

extension SFSymGen {
    struct Update: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Run the full symbol update pipeline in-process."
        )

        @OptionGroup var repo: RepoRoot

        @Option(help: "Path to the SF Symbols app (defaults to the first installed one).")
        var app: String?

        @Option(
            name: .customLong("draw-func"),
            help: "Override the auto-detected draw-check function address (e.g. 0x1000ec6bc) if Draw auto-extraction can't locate it in a new app build."
        )
        var drawFunc: String?

        func run() throws {
            let appPath: String
            if let app {
                appPath = app
            } else if let located = SymbolsApp.locate() {
                appPath = located
            } else {
                throw ValidationError("No SF Symbols app found in \(SymbolsApp.candidates.joined(separator: " or ")). Pass --app.")
            }

            var drawFuncAddr: UInt64?
            if let drawFunc {
                let hex = drawFunc.hasPrefix("0x") ? String(drawFunc.dropFirst(2)) : drawFunc
                guard let value = UInt64(hex, radix: 16) else {
                    throw ValidationError("--draw-func must be a hex address, e.g. 0x1000ec6bc")
                }
                drawFuncAddr = value
            }

            try runUpdate(appPath: appPath, repoRoot: repo.url, drawFunc: drawFuncAddr)
        }
    }

    struct Draw: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "draw",
            abstract: "Extract only the Draw category by driving the app's own hasDrawInfo logic, writing the symbol names to a file."
        )

        @Option(help: "Path to the SF Symbols app (defaults to the first installed one).")
        var app: String?

        @Option(name: .customLong("draw-func"), help: "Override the auto-detected draw-check function address (e.g. 0x1000ec6bc).")
        var drawFunc: String?

        @Option(help: "Output path for the extracted draw symbol names.")
        var output: String = "draw.txt"

        func run() throws {
            let appPath: String
            if let app {
                appPath = app
            } else if let located = SymbolsApp.locate() {
                appPath = located
            } else {
                throw ValidationError("No SF Symbols app found in \(SymbolsApp.candidates.joined(separator: " or ")). Pass --app.")
            }

            var drawFuncAddr: UInt64?
            if let drawFunc {
                let hex = drawFunc.hasPrefix("0x") ? String(drawFunc.dropFirst(2)) : drawFunc
                guard let value = UInt64(hex, radix: 16) else {
                    throw ValidationError("--draw-func must be a hex address, e.g. 0x1000ec6bc")
                }
                drawFuncAddr = value
            }

            let outputURL = URL(fileURLWithPath: output)
            guard extractDrawCategory(appPath: appPath, outputPath: outputURL, drawFunc: drawFuncAddr) else {
                throw ValidationError("Draw extraction failed. See the messages above.")
            }
        }
    }

    struct Wrappers: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Generate SwiftUI/UIKit wrapper extensions from an exported documentation RTF."
        )

        enum Kind: String, ExpressibleByArgument { case swiftui, uikit }

        @OptionGroup var repo: RepoRoot

        @Argument(help: "Which wrappers to generate: swiftui | uikit.")
        var kind: Kind

        @Option(help: "Path to the exported documentation RTF.")
        var rtf: String

        func run() throws {
            switch kind {
            case .swiftui:
                try generateSwiftUIWrappers(rtfPath: rtf, repoRoot: repo.url)
            case .uikit:
                try generateUIKitWrappers(rtfPath: rtf, repoRoot: repo.url)
            }
        }
    }
}
