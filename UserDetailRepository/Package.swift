// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDetailRepository",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "UserDetailRepository",
            targets: ["UserDetailRepository"]),
    ],
    dependencies: [
        .package(path: "../UserDetailUseCase"),
        .package(path: "../NetworkService")
    ],
    targets: [
        .target(
            name: "UserDetailRepository",
            dependencies: [
                "UserDetailUseCase",
                "NetworkService"
            ]),
        .testTarget(
            name: "UserDetailRepositoryTests",
            dependencies: ["UserDetailRepository"]
        ),
    ]
)
