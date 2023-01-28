// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Mortar",
    products: [
        .library(
            name: "Mortar",
            targets: ["Mortar"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Mortar",
            dependencies: [],
            path: "Mortar"),
        .testTarget(
            name: "MortarTests",
            dependencies: ["Mortar"],
            path: "MortarTests"),
    ]
)
