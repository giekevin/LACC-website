// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "Generator",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .upToNextMinor(from: Version(0, 8, 0))),
        ],
    targets: [
        .target(
            name: "generate",
            dependencies: [
                .productItem(name: "SDGCornerstone", package: "SDGCornerstone")
            ]),
        ]
)
