// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Generator",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 12, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", .exact(Version(0, 0, 2)))
        ],
    targets: [
        .target(
            name: "generate",
            dependencies: [
                .product(name: "SDGCornerstone", package: "SDGCornerstone"),
                .product(name: "SDGWeb", package: "SDGWeb")
            ],
            path: "Generator/Sources/generate"),
        ]
)
