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
            name: "SFSymbolsBinary",
            targets: ["SFSymbolsBinary"]
        )
    ],
    targets: [
        .target(
            name: "SFSymbols"
        ),
        .binaryTarget(
            name: "SFSymbolsBinary",
            path: "./SFSymbolKit.xcframework"
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]
        )
    ]
)
