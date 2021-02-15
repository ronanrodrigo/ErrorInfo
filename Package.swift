// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ErrorInfo",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "errorinfo", targets: ["ErrorInfo"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2")
    ],
    targets: [
        .target(name: "ErrorInfo", dependencies: ["SwiftSoup"])
    ]
)
