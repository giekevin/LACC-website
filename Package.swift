// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Generator",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 16, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", .exact(Version(0, 0, 3)))
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
