// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "autobuild",
    platforms: [
        .macOS(.v10_15) // Specify macOS 10.15 as the minimum requirement
    ],
    products: [
        .executable(
            name: "autobuild",
            targets: ["autobuild"]),
    ],
    dependencies: [
        .package(url: "https://github.com/webcpu/HaskellSwift.git", branch: "master")
    ],
    targets: [
        .target(name: "libc"),
//        .target(name: "HaskellSwift",
//                dependencies: [.product(name: "HaskellSwift", package: "HaskellSwift")]),
         .target(
            name: "POSIX",
            dependencies: ["libc"]),
        .target(
            name: "CommandLineKit",
            dependencies: ["libc"]),
        .target(
            name: "autobuild",
            dependencies: ["POSIX", "CommandLineKit", "libc", .product(name: "HaskellSwift", package: "HaskellSwift")]),
        .testTarget(
            name: "autobuildTests",
            dependencies: ["autobuild"]),
    ]
)

