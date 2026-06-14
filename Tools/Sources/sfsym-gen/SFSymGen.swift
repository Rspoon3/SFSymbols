import ArgumentParser
import Foundation
import SFSymbolsGenKit

@main
struct SFSymGen: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sfsym-gen",
        abstract: "Regenerate the SFSymbols library sources from the SF Symbols app.",
        discussion: """
        Maintainer tooling. Currently orchestrates the repo-root generation scripts; \
        run it from the repository root (or pass --repo-root).
        """,
        version: "0.1.0",
        subcommands: [Update.self, Wrappers.self]
    )
}

/// Shared `--repo-root` option (defaults to the current directory).
struct RepoRoot: ParsableArguments {
    @Option(name: .customLong("repo-root"), help: "Path to the SFSymbols repository root.")
    var path: String = FileManager.default.currentDirectoryPath

    var url: URL { URL(fileURLWithPath: path) }

    func script(_ name: String) -> String {
        url.appendingPathComponent(name).path
    }
}

extension SFSymGen {
    struct Update: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Run the full symbol update pipeline (UpdateScript.swift)."
        )

        @OptionGroup var repo: RepoRoot

        @Option(help: "Path to the SF Symbols app (defaults to the first installed one).")
        var app: String?

        func run() throws {
            let appPath: String
            if let app {
                appPath = app
            } else if let located = SymbolsApp.locate() {
                appPath = located
            } else {
                throw ValidationError("No SF Symbols app found in \(SymbolsApp.candidates.joined(separator: " or ")). Pass --app.")
            }
            try runSwiftScript(at: repo.script("UpdateScript.swift"), arguments: [appPath], workingDirectory: repo.url)
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
            let script = kind == .swiftui ? "ParseSwiftUIDoc.swift" : "ParseUIKitDoc.swift"
            try runSwiftScript(at: repo.script(script), arguments: [rtf], workingDirectory: repo.url)
        }
    }
}
