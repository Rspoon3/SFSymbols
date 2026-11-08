// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SFSymbols",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .watchOS(.v6),
        .tvOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SFSymbols",
            targets: ["SFSymbols"]
        ),
    ],
    targets: [
        .target(
            name: "SFSymbols",
            exclude: ["../../UpdateScript.swift"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
