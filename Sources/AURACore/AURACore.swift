import Foundation

/// Core namespace for AURA functionality
public enum AURACore {
    /// Current version of AURA
    public static let version = "2.0.0"
    
    /// Initialization check
    public static func initialize() async throws {
        print("AURACore initialized")
    }
}