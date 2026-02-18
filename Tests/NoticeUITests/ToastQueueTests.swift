import XCTest
import SwiftUI
@testable import NoticeUI

final class ToastQueueTests: XCTestCase {
    
    // MARK: - ToastQueueMode Tests
    
    func testQueueModeEnum() {
        // Verify all cases exist
        let modes: [ToastQueueMode] = [.fifo, .replaceAll, .priority]
        XCTAssertEqual(modes.count, 3)
    }
    
    // MARK: - ToastRole Priority Tests
    
    func testRolePriority() {
        XCTAssertGreaterThan(ToastRole.error.queuePriority, ToastRole.warning.queuePriority)
        XCTAssertGreaterThan(ToastRole.warning.queuePriority, ToastRole.success.queuePriority)
        XCTAssertGreaterThan(ToastRole.success.queuePriority, ToastRole.info.queuePriority)
    }
    
    func testRolePriorityValues() {
        XCTAssertEqual(ToastRole.error.queuePriority, 3)
        XCTAssertEqual(ToastRole.warning.queuePriority, 2)
        XCTAssertEqual(ToastRole.success.queuePriority, 1)
        XCTAssertEqual(ToastRole.info.queuePriority, 0)
    }
    
    func testPrioritySortOrder() {
        let toasts = [
            Toast(message: "Info", role: .info),
            Toast(message: "Error", role: .error),
            Toast(message: "Success", role: .success),
            Toast(message: "Warning", role: .warning)
        ]
        
        let sorted = toasts.sorted { $0.role.queuePriority > $1.role.queuePriority }
        
        XCTAssertEqual(sorted[0].role, .error)
        XCTAssertEqual(sorted[1].role, .warning)
        XCTAssertEqual(sorted[2].role, .success)
        XCTAssertEqual(sorted[3].role, .info)
    }
    
    // MARK: - Toast Identity Tests (relevant to queue deduplication)
    
    func testToastsHaveUniqueIDs() {
        let toast1 = Toast(message: "Same", role: .info)
        let toast2 = Toast(message: "Same", role: .info)
        
        XCTAssertNotEqual(toast1.id, toast2.id, "Each toast should have a unique ID for queue tracking")
    }
    
    func testToastPreservesAllProperties() {
        let toast = Toast(
            title: "Title",
            message: "Test",
            role: .error,
            icon: "star.fill",
            placement: .bottom,
            duration: .long,
            haptic: .heavy,
            actions: [
                ToastAction(title: "Retry") { }
            ]
        )
        
        XCTAssertEqual(toast.title, .custom(LocalizedStringKey("Title"), "Title"))
        XCTAssertEqual(toast.messageString, "Test")
        XCTAssertEqual(toast.role, .error)
        XCTAssertEqual(toast.icon, "star.fill")
        XCTAssertEqual(toast.placement, .bottom)
        XCTAssertEqual(toast.duration, .long)
        XCTAssertEqual(toast.haptic, .heavy)
        XCTAssertEqual(toast.actions.count, 1)
        XCTAssertEqual(toast.actions.first?.titleString, "Retry")
    }
    
    // MARK: - Priority Sort Stability
    
    func testPrioritySortStabilityWithSameRole() {
        let toast1 = Toast(message: "First info", role: .info)
        let toast2 = Toast(message: "Second info", role: .info)
        let toast3 = Toast(message: "Third info", role: .info)
        
        var queue = [toast1, toast2, toast3]
        queue.sort { $0.role.queuePriority > $1.role.queuePriority }
        
        // Same priority toasts should maintain relative order
        XCTAssertEqual(queue[0].messageString, "First info")
        XCTAssertEqual(queue[1].messageString, "Second info")
        XCTAssertEqual(queue[2].messageString, "Third info")
    }
    
    func testPriorityInsertionOrder() {
        var queue: [Toast] = [
            Toast(message: "Existing info", role: .info),
            Toast(message: "Existing success", role: .success)
        ]
        
        // Append a new error toast
        queue.append(Toast(message: "New error", role: .error))
        
        // Sort by priority
        queue.sort { $0.role.queuePriority > $1.role.queuePriority }
        
        // Error should now be first
        XCTAssertEqual(queue[0].role, .error)
        XCTAssertEqual(queue[0].messageString, "New error")
    }
}
