// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveStorage",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ReactiveStorage",
            targets: ["ReactiveStorage"]),
    ],
    targets: [
        .target(
            name: "ReactiveStorage"
        ),
        .testTarget(
            name: "ReactiveStorageTests",
            dependencies: [
                "ReactiveStorage"
            ]
        ),
    ]
)
