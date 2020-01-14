// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Generator",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(4, 2, 0)),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", from: Version(5, 0, 0)),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", from: Version(1, 2, 5))
        ],
    targets: [
        .target(
            name: "generate",
            dependencies: [
                .product(name: "SDGLogic", package: "SDGCornerstone"),
                .product(name: "SDGCollections", package: "SDGCornerstone"),
                .product(name: "SDGText", package: "SDGCornerstone"),
                .product(name: "SDGLocalization", package: "SDGCornerstone"),
                .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
                .product(name: "SDGWeb", package: "SDGWeb"),
                .product(name: "SDGCommandLine", package: "SDGCommandLine"),
            ],
            path: "Generator/Sources/generate"),
        ]
)
