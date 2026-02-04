import XCTest
@testable import NoticeUI

final class NoticeUITests: XCTestCase {
    
    // MARK: - Toast Duration Tests
    
    func testDurationTimeIntervals() {
        XCTAssertEqual(ToastDuration.short.timeInterval, 2.0, "Short duration should be 2.0 seconds")
        XCTAssertEqual(ToastDuration.long.timeInterval, 4.0, "Long duration should be 4.0 seconds")
        XCTAssertEqual(ToastDuration.custom(5.5).timeInterval, 5.5, "Custom duration should match the provided value")
        XCTAssertNil(ToastDuration.indefinite.timeInterval, "Indefinite duration should have nil timeInterval")
    }
    
    // MARK: - Toast Model Tests
    
    func testToastInitialization() {
        let toast = Toast(
            message: "Test Message",
            role: .success,
            placement: .top,
            duration: .short
        )
        
        XCTAssertEqual(toast.message, "Test Message")
        XCTAssertEqual(toast.role, .success)
        XCTAssertEqual(toast.placement, .top)
        XCTAssertEqual(toast.duration, .short)
    }
    
    func testToastEquality() {
        let toast1 = Toast(message: "A", role: .info)
        let toast2 = Toast(message: "A", role: .info)
        let toast3 = Toast(message: "B", role: .info)
        
        XCTAssertNotEqual(toast1, toast2, "Toasts have unique IDs, so separate instances should not be equal")
        XCTAssertNotEqual(toast1, toast3, "Different content should definitely not be equal")
        
        XCTAssertEqual(toast1.message, toast2.message)
        XCTAssertEqual(toast1.role, toast2.role)
    }
    
    // MARK: - Toast Role Tests
    
    func testToastRoleCases() {
        let roles: [ToastRole] = [.success, .error, .warning, .info]
        XCTAssertEqual(roles.count, 4)
    }
}
