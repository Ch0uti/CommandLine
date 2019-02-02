// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "CommandLineKit",
  products: [
    .library(
      name: "CommandLineKit",
      targets: ["CommandLineKit"]
    ),
  ],
  dependencies: [
    // development dependencies
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.37.2"),
  ],
  targets: [
    .target(
      name: "CommandLineKit",
      dependencies: []
    ),
    .testTarget(
      name: "CommandLineKitTests",
      dependencies: ["CommandLineKit"]
    ),
  ]
)
