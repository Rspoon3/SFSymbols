// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SFSymbols",
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
        .library(
            name: "SFSymbolsDynamic",
            type: .dynamic,
            targets: ["SFSymbols"]
        )
    ],
    targets: [
        .target(
            name: "SFSymbols",
            exclude: ["../../UpdateScript.swift"]
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]
        ),
    ]
)
