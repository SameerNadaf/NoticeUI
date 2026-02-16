import XCTest
@testable import NoticeUI

final class ToastModelTests: XCTestCase {
    
    func testToastInitialization() {
        let toast = Toast(
            message: "Test Message",
            role: .success,
            placement: .top,
            duration: .short
        )
        
        XCTAssertEqual(toast.title, .automatic)
        XCTAssertEqual(toast.message, "Test Message")
        XCTAssertEqual(toast.role, .success)
        XCTAssertEqual(toast.placement, .top)
        XCTAssertEqual(toast.duration, .short)
        XCTAssertNotNil(toast.id)
    }
    
    func testToastEquality() {
        let toast1 = Toast(message: "A", role: .info)
        let toast2 = Toast(message: "A", role: .info)
        let toast3 = Toast(message: "B", role: .info)
        
        // Even with same content, IDs are unique
        XCTAssertNotEqual(toast1, toast2, "Toasts have unique IDs, so separate instances should not be equal")
        XCTAssertNotEqual(toast1, toast3, "Different content should definitely not be equal")
        
        XCTAssertEqual(toast1.message, toast2.message)
        XCTAssertEqual(toast1.role, toast2.role)
        XCTAssertEqual(toast1.title, toast2.title)
    }
    
    func testToastWithCustomTitle() {
        let toast = Toast(title: "Custom", message: "Msg")
        XCTAssertEqual(toast.title, .custom("Custom"))
    }
    
    func testToastWithNoTitle() {
        let toast = Toast(title: nil, message: "Msg")
        XCTAssertEqual(toast.title, .none)
    }
    
    func testToastCustomIcon() {
        let toast = Toast(message: "Icon Test", role: .info, icon: "star.fill")
        XCTAssertEqual(toast.icon, "star.fill")
    }
}
