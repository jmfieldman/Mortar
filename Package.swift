// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Mortar",
    platforms: [.iOS(.v12), .tvOS(.v12), .macOS(.v10_14)],
    products: [
        .library(
            name: "Mortar",
            targets: ["Mortar"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Mortar",
            dependencies: [],
            path: "Mortar"
        ),
        .testTarget(
            name: "MortarTests",
            dependencies: ["Mortar"],
            path: "MortarTests"
        ),
    ]
)
