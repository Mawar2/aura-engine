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
    ],
    dependencies: [
        // We'll add dependencies as needed
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
        .testTarget(
            name: "AURACoreTests",
            dependencies: ["AURACore"]
        ),
    ]
)