// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Generator",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(2, 6, 0)),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", from: Version(3, 1, 0)),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", from: Version(1, 2, 0))
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
