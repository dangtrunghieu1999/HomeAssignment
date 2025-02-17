// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeUerListRepository",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "HomeUerListRepository",
            targets: ["HomeUerListRepository"]),
    ],
    dependencies: [
        .package(path: "../HomeUserListUseCase"),
        .package(path: "../NetworkService")
    ],
    targets: [
        .target(
            name: "HomeUerListRepository",
            dependencies: [
                "HomeUserListUseCase",
                "NetworkService"
            ]),
        .testTarget(
            name: "HomeUerListRepositoryTests",
            dependencies: ["HomeUerListRepository"]
        ),
    ]
)
