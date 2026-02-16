import XCTest
@testable import NoticeUI

final class ToastTitleTests: XCTestCase {
    
    func testToastTitleEnumCases() {
        let automatic = ToastTitle.automatic
        let custom = ToastTitle.custom("My Title")
        let none = ToastTitle.none
        
        switch automatic {
        case .automatic: XCTAssertTrue(true)
        default: XCTFail("Expected .automatic")
        }
        
        switch custom {
        case .custom(let text): XCTAssertEqual(text, "My Title")
        default: XCTFail("Expected .custom")
        }
        
        switch none {
        case .none: XCTAssertTrue(true)
        default: XCTFail("Expected .none")
        }
    }
    
    func testStringLiteralInitialization() {
        let title: ToastTitle = "Hello World"
        
        if case .custom(let text) = title {
            XCTAssertEqual(text, "Hello World")
        } else {
            XCTFail("String literal should create .custom case")
        }
    }
    
    func testNilLiteralInitialization() {
        let title: ToastTitle = nil
        
        if case .none = title {
            XCTAssertTrue(true)
        } else {
            XCTFail("Nil literal should create .none case")
        }
    }
    
    func testEquality() {
        XCTAssertEqual(ToastTitle.automatic, ToastTitle.automatic)
        XCTAssertEqual(ToastTitle.none, ToastTitle.none)
        XCTAssertEqual(ToastTitle.custom("A"), ToastTitle.custom("A"))
        XCTAssertNotEqual(ToastTitle.custom("A"), ToastTitle.custom("B"))
        XCTAssertNotEqual(ToastTitle.automatic, ToastTitle.none)
    }
}
