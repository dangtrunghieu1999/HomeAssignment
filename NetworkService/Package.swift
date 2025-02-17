// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v13), .macOS(.v12)],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: []),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"]),
    ]
)
