// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SFSymbols",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SFSymbols",
            targets: ["SFSymbols"]),
    ],
    targets: [
        .target(
            name: "SFSymbols"
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]),
    ]
)
