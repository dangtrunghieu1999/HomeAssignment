// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDetailUseCase",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "UserDetailUseCase",
            targets: ["UserDetailUseCase"]),
    ],
    targets: [
        .target(
            name: "UserDetailUseCase"),
        .testTarget(
            name: "UserDetailUseCaseTests",
            dependencies: ["UserDetailUseCase"]
        ),
    ]
)
