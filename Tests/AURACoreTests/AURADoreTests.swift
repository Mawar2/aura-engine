import XCTest
@testable import AURACore

final class AURACoreTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(AURACore.version, "2.0.0")
    }
    
    func testInitialization() async throws {
        // This should not throw
        try await AURACore.initialize()
    }
}