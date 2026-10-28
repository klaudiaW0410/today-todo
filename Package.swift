// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TodayWidget",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "TodayWidget", targets: ["TodayWidget"])
    ],
    targets: [
        .executableTarget(
            name: "TodayWidget",
            path: "Sources/TodayWidget"
        ),
        .testTarget(
            name: "TodayWidgetTests",
            dependencies: ["TodayWidget"],
            path: "Tests/TodayWidgetTests"
        )
    ]
)
