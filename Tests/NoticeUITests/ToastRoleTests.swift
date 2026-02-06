import XCTest
@testable import NoticeUI

final class ToastRoleTests: XCTestCase {
    
    func testToastRoleCases() {
        let roles: [ToastRole] = [.success, .error, .warning, .info]
        XCTAssertEqual(roles.count, 4)
        
        XCTAssertTrue(roles.contains(.success))
        XCTAssertTrue(roles.contains(.error))
        XCTAssertTrue(roles.contains(.warning))
        XCTAssertTrue(roles.contains(.info))
    }
    
    func testRoleIdentifiable() {
        // Ensure roles can be identified/equated correctly
        XCTAssertEqual(ToastRole.success, ToastRole.success)
        XCTAssertNotEqual(ToastRole.error, ToastRole.warning)
    }
}
