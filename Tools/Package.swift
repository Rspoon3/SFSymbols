// swift-tools-version: 6.0
//
// Maintainer tooling for the SFSymbols library. This is a SEPARATE package with
// its own manifest, so it is invisible to anyone who depends on the SFSymbols
// library (SPM never reads nested manifests) — the library stays dependency-free.
//
//   sfsym-gen — regenerate the library sources from the SF Symbols app.
//
// The read-only query CLI is intentionally NOT here: it wants an ungated,
// host-independent dataset rather than the library's runtime symbol list, so it
// belongs in its own repository with its own published data source.
//
// Build/run from the repo root, e.g.:
//   swift run --package-path Tools sfsym-gen update --app "/Applications/SF Symbols Beta.app"

import PackageDescription

let package = Package(
    name: "SFSymbolsTools",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(name: "SFSymbolsGenKit", exclude: ["README.md"]),
        .executableTarget(
            name: "sfsym-gen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SFSymbolsGenKit",
            ],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"])]
        ),
    ],
    swiftLanguageModes: [.v6]
)
