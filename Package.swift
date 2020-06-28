// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Propellor",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Propellor",
            targets: ["Propellor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tokyovigilante/Termbox", .branch("master")),
        .package(url: "https://github.com/tokyovigilante/Harness", .branch("master")),
    ],
    targets: [
        .target(
            name: "Propellor",
            dependencies: [
                "Termbox",
                "Harness"
            ]
        ),
        .testTarget(
            name: "PropellorTests",
            dependencies: ["Propellor"]),
    ]
)
