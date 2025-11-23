// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DyadSampleApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DyadSampleApp",
            targets: ["DyadSampleApp"]),
    ],
    dependencies: [
        // Add Swift Package Dependencies here
        // Example:
        // .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    ],
    targets: [
        .target(
            name: "DyadSampleApp",
            dependencies: []),
        .testTarget(
            name: "DyadSampleAppTests",
            dependencies: ["DyadSampleApp"]),
    ]
)
