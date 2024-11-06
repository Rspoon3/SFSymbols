// swift-tools-version: 6.0

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
    ],
    targets: [
        .target(
            name: "SFSymbols",
            exclude: ["../../SFSymbolsDemo"]
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]
        ),
    ]
)
