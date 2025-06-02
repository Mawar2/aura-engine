/// VoiceEngine Module
/// Provides speech recognition and synthesis capabilities for AURA

// Re-export public APIs
@_exported import Foundation

// Export public protocols and types
public protocol VoiceEngineProtocol {
    var wakeWordDetector: WakeWordDetector { get }
}

/// Main VoiceEngine implementation
public class VoiceEngine: VoiceEngineProtocol {
    public let wakeWordDetector: WakeWordDetector
    
    public init(wakeWordDetector: WakeWordDetector = CoreAudioWakeWordDetector()) {
        self.wakeWordDetector = wakeWordDetector
    }
}