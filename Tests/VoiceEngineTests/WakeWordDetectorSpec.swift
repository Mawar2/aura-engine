import Quick
import Nimble
import Foundation
@testable import VoiceEngine

class WakeWordDetectorSpec: QuickSpec {
    override class func spec() {
        describe("WakeWordDetector") {
            var detector: MockWakeWordDetector!
            var delegate: MockWakeWordDelegate!
            
            beforeEach {
                delegate = MockWakeWordDelegate()
                detector = MockWakeWordDetector()
                detector.delegate = delegate
            }
            
            describe("lifecycle management") {
                it("should start detection successfully") {
                    waitUntil { done in
                        Task {
                            do {
                                try await detector.startDetection()
                                expect(detector.isDetecting).to(beTrue())
                                done()
                            } catch {
                                fail("Should not throw error: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("should stop detection successfully") {
                    waitUntil { done in
                        Task {
                            do {
                                try await detector.startDetection()
                                await detector.stopDetection()
                                expect(detector.isDetecting).to(beFalse())
                                done()
                            } catch {
                                fail("Should not throw error: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("should not start detection when already detecting") {
                    waitUntil { done in
                        Task {
                            do {
                                try await detector.startDetection()
                                try await detector.startDetection()
                                fail("Should have thrown alreadyDetecting error")
                                done()
                            } catch WakeWordError.alreadyDetecting {
                                // Expected error
                                done()
                            } catch {
                                fail("Wrong error type: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("should handle stop when not detecting gracefully") {
                    waitUntil { done in
                        Task {
                            await detector.stopDetection()
                            expect(detector.isDetecting).to(beFalse())
                            done()
                        }
                    }
                }
            }
            
            describe("wake word detection") {
                beforeEach {
                    waitUntil { done in
                        Task {
                            try! await detector.startDetection()
                            done()
                        }
                    }
                }
                
                it("should detect 'Hey AURA' with high confidence") {
                    waitUntil { done in
                        Task {
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.95)
                            
                            expect(delegate.detectionCallCount).to(equal(1))
                            expect(delegate.lastDetectedPhrase).to(equal("Hey AURA"))
                            expect(delegate.lastConfidence).to(beCloseTo(0.95, within: 0.01))
                            done()
                        }
                    }
                }
                
                it("should not trigger on low confidence detections") {
                    waitUntil { done in
                        Task {
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.3)
                            
                            expect(delegate.detectionCallCount).to(equal(0))
                            done()
                        }
                    }
                }
                
                it("should not trigger on different phrases") {
                    waitUntil { done in
                        Task {
                            await detector.simulateWakeWordDetection(phrase: "Hey Siri", confidence: 0.95)
                            
                            expect(delegate.detectionCallCount).to(equal(0))
                            done()
                        }
                    }
                }
                
                it("should handle multiple rapid detections") {
                    waitUntil { done in
                        Task {
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.95)
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.90)
                            
                            expect(delegate.detectionCallCount).to(equal(2))
                            done()
                        }
                    }
                }
            }
            
            describe("error handling") {
                it("should handle audio processing errors") {
                    waitUntil { done in
                        Task {
                            try! await detector.startDetection()
                            await detector.simulateError(.audioProcessingFailed)
                            
                            expect(delegate.errorCallCount).to(equal(1))
                            expect(delegate.lastError).to(matchError(WakeWordError.audioProcessingFailed))
                            done()
                        }
                    }
                }
                
                it("should handle microphone permission errors") {
                    waitUntil { done in
                        Task {
                            detector.shouldFailPermissions = true
                            do {
                                try await detector.startDetection()
                                fail("Should have thrown permission error")
                                done()
                            } catch WakeWordError.microphonePermissionDenied {
                                // Expected error
                                done()
                            } catch {
                                fail("Wrong error type: \(error)")
                                done()
                            }
                        }
                    }
                }
                
                it("should handle model loading errors") {
                    waitUntil { done in
                        Task {
                            detector.shouldFailModelLoading = true
                            do {
                                try await detector.startDetection()
                                fail("Should have thrown model loading error")
                                done()
                            } catch WakeWordError.modelLoadingFailed {
                                // Expected error
                                done()
                            } catch {
                                fail("Wrong error type: \(error)")
                                done()
                            }
                        }
                    }
                }
            }
            
            describe("configuration") {
                it("should allow confidence threshold adjustment") {
                    waitUntil { done in
                        Task {
                            detector.confidenceThreshold = 0.8
                            try! await detector.startDetection()
                            
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.85)
                            expect(delegate.detectionCallCount).to(equal(1))
                            
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.75)
                            expect(delegate.detectionCallCount).to(equal(1)) // Still 1, not triggered
                            done()
                        }
                    }
                }
                
                it("should have reasonable default threshold") {
                    expect(detector.confidenceThreshold).to(beCloseTo(0.7, within: 0.1))
                }
            }
            
            describe("performance") {
                it("should process audio within reasonable time limits") {
                    waitUntil { done in
                        Task {
                            try! await detector.startDetection()
                            
                            let startTime = Date()
                            await detector.simulateWakeWordDetection(phrase: "Hey AURA", confidence: 0.95)
                            let processingTime = Date().timeIntervalSince(startTime)
                            
                            expect(processingTime).to(beLessThan(0.1)) // 100ms max
                            done()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Mock Implementations

class MockWakeWordDelegate: WakeWordDetectorDelegate {
    var detectionCallCount = 0
    var errorCallCount = 0
    var lastDetectedPhrase: String?
    var lastConfidence: Float?
    var lastError: WakeWordError?
    
    func wakeWordDetected(phrase: String, confidence: Float) {
        detectionCallCount += 1
        lastDetectedPhrase = phrase
        lastConfidence = confidence
    }
    
    func wakeWordDetectionError(_ error: WakeWordError) {
        errorCallCount += 1
        lastError = error
    }
}

class MockWakeWordDetector: WakeWordDetector {
    weak var delegate: WakeWordDetectorDelegate?
    var confidenceThreshold: Float = 0.7
    var isDetecting = false
    
    // Test configuration
    var shouldFailPermissions = false
    var shouldFailModelLoading = false
    
    func startDetection() async throws {
        if isDetecting {
            throw WakeWordError.alreadyDetecting
        }
        
        if shouldFailPermissions {
            throw WakeWordError.microphonePermissionDenied
        }
        
        if shouldFailModelLoading {
            throw WakeWordError.modelLoadingFailed
        }
        
        isDetecting = true
    }
    
    func stopDetection() async {
        isDetecting = false
    }
    
    // Test helpers
    func simulateWakeWordDetection(phrase: String, confidence: Float) async {
        guard isDetecting else { return }
        
        if phrase == "Hey AURA" && confidence >= confidenceThreshold {
            delegate?.wakeWordDetected(phrase: phrase, confidence: confidence)
        }
    }
    
    func simulateError(_ error: WakeWordError) async {
        delegate?.wakeWordDetectionError(error)
    }
}