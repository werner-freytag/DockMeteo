// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewLibrary",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "ViewLibrary",
            targets: ["ViewLibrary"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/werner-freytag/SwiftToolbox.git", .branch("develop")),
    ],
    targets: [
        .target(
            name: "ViewLibrary",
            dependencies: ["SwiftToolbox"]
        ),
    ]
)
