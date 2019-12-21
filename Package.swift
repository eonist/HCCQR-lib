// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HCCQR-lib",
    platforms: [.iOS(.v12), .macOS(.v10_13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "HCCQR-lib",
            targets: ["HCCQR-lib"]),
        .library(
            name: "HCCQR-demo-mac",
            targets: ["HCCQR-demo-mac"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/light-stream/QR-lib.git", .branch("master")),
        .package(url: "https://github.com/eonist/ResultSugar.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HCCQR-lib",
            dependencies: ["QR-lib", "ResultSugar"]),
        .target(
            name: "HCCQR-demo-mac",
            dependencies: ["QR-lib", "ResultSugar"],
            path: "Sources/HCCQR-lib/"), //path for target to look for sources

        .testTarget(
            name: "HCCQRIOSTest",
            dependencies: ["HCCQR-lib", "HCCQR-demo-mac", "QR-lib", "ResultSugar"])
    ]
)
