// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IsometrikStream",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IsometrikStream",
            targets: ["IsometrikStream"]
        ),
        .library(
            name: "IsometrikStreamUI",
            targets: ["IsometrikStreamUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift", from: "2.0.7"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.4.3"),
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.1.1"),
        .package(url: "https://github.com/jdg/MBProgressHUD", from: "1.2.0"),
        .package(url: "https://github.com/cloudinary/cloudinary_ios", from: "5.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", from: "5.0.2"),
        .package(url: "https://github.com/emqx/CocoaMQTT", from: "2.1.6"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.12.0"),
        .package(url: "https://github.com/kasketis/netfox", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "IsometrikStream",
            dependencies: [
                .product(name: "LiveKit", package: "client-sdk-swift"),
                .product(name: "CocoaMQTT", package: "cocoamqtt"),
                .product(name: "SwiftyJSON", package: "swiftyjson")
            ]
        ),
        .target(
            name: "IsometrikStreamUI",
            dependencies: [
                "IsometrikStream",
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Toast", package: "toast-swift"),
                .product(name: "MBProgressHUD", package: "mbprogresshud"),
                .product(name: "Cloudinary", package: "cloudinary_ios"),
                .product(name: "Kingfisher", package: "kingfisher"),
                .product(name: "netfox", package: "netfox")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
