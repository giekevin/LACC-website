// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Generator",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 18, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", .exact(Version(0, 1, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(0, 7, 1)))
        ],
    targets: [
        .target(
            name: "generate",
            dependencies: [
                .product(name: "SDGLogic", package: "SDGCornerstone"),
                .product(name: "SDGCornerstone", package: "SDGCornerstone"),
                .product(name: "SDGWeb", package: "SDGWeb"),
                .product(name: "SDGCommandLine", package: "SDGCommandLine"),
            ],
            path: "Generator/Sources/generate"),
        ]
)
