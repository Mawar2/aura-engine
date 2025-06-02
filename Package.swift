// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AURA",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "aura", targets: ["AURA"]),
        .library(name: "AURACore", targets: ["AURACore"]),
        .library(name: "VoiceEngine", targets: ["VoiceEngine"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "7.6.2"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.7.1")
    ],
    targets: [
        .executableTarget(
            name: "AURA",
            dependencies: ["AURACore"]
        ),
        .target(
            name: "AURACore",
            dependencies: []
        ),
        .target(
            name: "VoiceEngine",
            dependencies: ["AURACore"]
        ),
        .testTarget(
            name: "AURACoreTests",
            dependencies: ["AURACore"]
        ),
        .testTarget(
            name: "VoiceEngineTests",
            dependencies: ["VoiceEngine", "Quick", "Nimble"]
        )
    ]
)