// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "urlcomponents",
    targets: [
        .target(name: "urlcomponents"),
        .testTarget(name: "URLComponentsTests", dependencies: ["urlcomponents"]),
    ]
)
