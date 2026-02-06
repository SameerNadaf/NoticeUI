import XCTest
@testable import NoticeUI

final class ToastDurationTests: XCTestCase {
    
    func testDurationTimeIntervals() {
        XCTAssertEqual(ToastDuration.short.timeInterval, 2.0, "Short duration should be 2.0 seconds")
        XCTAssertEqual(ToastDuration.long.timeInterval, 4.0, "Long duration should be 4.0 seconds")
        XCTAssertEqual(ToastDuration.custom(5.5).timeInterval, 5.5, "Custom duration should match the provided value")
        XCTAssertNil(ToastDuration.indefinite.timeInterval, "Indefinite duration should have nil timeInterval")
    }
    
    func testDurationEquality() {
        XCTAssertEqual(ToastDuration.short, ToastDuration.short)
        XCTAssertEqual(ToastDuration.long, ToastDuration.long)
        XCTAssertEqual(ToastDuration.indefinite, ToastDuration.indefinite)
        XCTAssertEqual(ToastDuration.custom(3.0), ToastDuration.custom(3.0))
        XCTAssertNotEqual(ToastDuration.short, ToastDuration.long)
    }
}
