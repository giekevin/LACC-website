// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "Generator",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 11, 0))),
        ],
    targets: [
        .target(
            name: "generate",
            dependencies: [
                .productItem(name: "SDGCornerstone", package: "SDGCornerstone")
            ],
            path: "Generator/Sources/generate"),
        ]
)
