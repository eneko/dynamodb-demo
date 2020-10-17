// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "dynamodb-demo",
    dependencies: [
        .package(url: "https://github.com/soto-project/soto", from: "5.0.0-beta.2")
    ],
    targets: [
        .target(name: "dynamodb-demo", dependencies: [
            .product(name: "SotoDynamoDB", package: "soto"),
        ]),
        .testTarget(name: "dynamodb-demoTests", dependencies: ["dynamodb-demo"]),
    ]
)
