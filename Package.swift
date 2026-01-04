// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PomodoroApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "PomodoroApp", targets: ["PomodoroApp"])
    ],
    targets: [
        .executableTarget(
            name: "PomodoroApp",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
