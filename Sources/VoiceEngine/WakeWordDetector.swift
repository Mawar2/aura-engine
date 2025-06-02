import Foundation

/**
 Protocol for wake word detection functionality
 
 `WakeWordDetector` provides the core interface for detecting wake words in audio streams.
 Designed specifically for AURA's "Hey AURA" wake word detection on Apple Silicon Macs.
 
 ## Features
 - **Async/Await Support**: Full async/await pattern for modern Swift concurrency
 - **Configurable Confidence**: Adjustable threshold for detection sensitivity  
 - **Delegate-Based Events**: Clean separation of detection events and business logic
 - **Testable Design**: Protocol-oriented for easy mocking and testing
 - **M1 Optimized**: Leverages Apple Silicon for efficient audio processing
 
 ## Usage Example
 ```swift
 let detector = CoreAudioWakeWordDetector()
 detector.delegate = self
 detector.confidenceThreshold = 0.8
 
 try await detector.startDetection()
 // Will call delegate.wakeWordDetected when "Hey AURA" is detected
 ```
 
 ## Threading
 All methods are safe to call from any thread. Delegate callbacks are delivered on the main queue.
 
 ## Performance
 Optimized for continuous operation with minimal CPU usage and low latency detection.
 */
public protocol WakeWordDetector: AnyObject {
    /// Delegate for handling detection events
    var delegate: WakeWordDetectorDelegate? { get set }
    
    /// Confidence threshold for wake word detection (0.0-1.0)
    var confidenceThreshold: Float { get set }
    
    /// Current detection state
    var isDetecting: Bool { get }
    
    /// Start continuous wake word detection
    /// - Throws: WakeWordError if detection cannot be started
    func startDetection() async throws
    
    /// Stop wake word detection
    func stopDetection() async
}

/// Delegate protocol for wake word detection events
public protocol WakeWordDetectorDelegate: AnyObject {
    /// Called when wake word is detected with sufficient confidence
    /// - Parameters:
    ///   - phrase: The detected wake word phrase
    ///   - confidence: Detection confidence score (0.0-1.0)
    func wakeWordDetected(phrase: String, confidence: Float)
    
    /// Called when detection error occurs
    /// - Parameter error: The error that occurred
    func wakeWordDetectionError(_ error: WakeWordError)
}

/// Errors that can occur during wake word detection
public enum WakeWordError: Error, Equatable {
    case microphonePermissionDenied
    case audioProcessingFailed
    case modelLoadingFailed
    case alreadyDetecting
    case invalidConfiguration
}

extension WakeWordError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return "Microphone permission is required for wake word detection"
        case .audioProcessingFailed:
            return "Failed to process audio data"
        case .modelLoadingFailed:
            return "Failed to load wake word detection model"
        case .alreadyDetecting:
            return "Wake word detection is already running"
        case .invalidConfiguration:
            return "Invalid wake word detector configuration"
        }
    }
}