// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-lgpio-wrapper",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GPIOD",
            targets: ["SwiftyGPIOD"]),
    ],
    dependencies: [.package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")],
    targets: [
        .target(
            name: "SwiftyGPIOD",
            dependencies: ["CGPIOD"]
        ),

        .executableTarget(
            name: "Examples", 
            dependencies: [
                .target(name: "SwiftyGPIOD"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),

        .systemLibrary(
            name: "CGPIOD", 
            path: nil, 
            pkgConfig: nil, 
            providers: [
                .apt(["libgpiod-dev"])
            ]
        ),

        .testTarget(
            name: "SwiftyGPIODTests",
            dependencies: ["SwiftyGPIOD"]),
    ]
)
