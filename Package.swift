// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NoticeUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "NoticeUI",
            targets: ["NoticeUI"]
        ),
    ],
    targets: [
        .target(
            name: "NoticeUI"
        ),
        .testTarget(
            name: "NoticeUITests",
            dependencies: ["NoticeUI"]
        ),
    ]
)
