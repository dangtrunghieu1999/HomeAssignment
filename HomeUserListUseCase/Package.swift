// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeUserListUseCase",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "HomeUserListUseCase",
            targets: ["HomeUserListUseCase"]),
    ],
    targets: [
        .target(
            name: "HomeUserListUseCase"),
        .testTarget(
            name: "HomeUserListUseCaseTests",
            dependencies: ["HomeUserListUseCase"]
        ),
    ]
)
