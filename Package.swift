// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-lgpio-wrapper",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftyLGPIO",
            targets: ["SwiftyLGPIO"]),
    ],
    dependencies: [.package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftyLGPIO",
            dependencies: ["CLGPIO"]
        ),

        .target(
            name: "SwiftyGPIOD",
            dependencies: ["CGPIOD", "CGPIODHelpers"]
        ),

        .executableTarget(
            name: "Examples", 
            dependencies: [
                .target(name: "SwiftyLGPIO"),
                .target(name: "SwiftyGPIOD"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),

        .systemLibrary(
            name: "CLGPIO", 
            path: nil, 
            pkgConfig: nil, 
            providers: [
                .apt(["liblgpio-dev"])
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

        .target(
            name: "CGPIODHelpers",
            dependencies: []
        ),

        .testTarget(
            name: "swift-lgpio-wrapperTests",
            dependencies: ["SwiftyLGPIO"]),
    ]
)
