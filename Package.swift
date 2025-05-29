// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Mortar",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(
            name: "Mortar",
            targets: ["Mortar"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jmfieldman/CombineEx.git",
            from: "0.0.8"
        ),
    ],
    targets: [
        .target(
            name: "Mortar",
            dependencies: ["CombineEx"],
            path: "Mortar"
        ),
        .testTarget(
            name: "MortarTests",
            dependencies: ["Mortar"],
            path: "MortarTests"
        ),
    ]
)
