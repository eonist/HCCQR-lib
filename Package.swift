// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HCCQR-lib",
    platforms: [.iOS(.v13), .macOS(.v10_13)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "HCCQR-lib",
            targets: ["HCCQR-lib"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://eonist:2fa35e4ff44eac34e98f01f2c83a16f00e650e56@github.com/light-stream/QR-lib.git", .branch("master")),
        .package(url: "https://github.com/eonist/ResultSugar.git", .branch("master")),
        .package(url: "https://github.com/eonist/ResourceHelper.git", .branch("master")),
        .package(url: "https://github.com/passbook/ParallelLoop.git", .branch("master")),
        .package(url: "https://github.com/eonist/TimeMeasure.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HCCQR-lib",
            dependencies: ["QR-lib", "ResultSugar", "ParallelLoop"]),
        .testTarget(
            name: "HCCQRIOSTest",
            dependencies: ["HCCQR-lib", "QR-lib", "ResultSugar", "ResourceHelper", "ParallelLoop", "TimeMeasure"])
    ]
)
