import XCTest
@testable import AVRKit

class FixedWidthIntegerTest: XCTestCase {
    func testMask() {
        XCTAssertEqual((0x53ff as UInt16).mask(0x5001), 7)
        XCTAssertEqual((0x53f0 as UInt16).mask(0x020f), 16)
        XCTAssertEqual((0x53f0 as UInt16).mask(0x01f0), 31)
    }
    
    func testFromBytes() {
        XCTAssertEqual(UInt8.fromBytes([0x11, 0x22]), 0x11)
        XCTAssertEqual(UInt16.fromBytes([0x11, 0x22]), 0x1122)
        XCTAssertEqual(UInt32.fromBytes([0x11, 0x22, 0x33, 0x44]), 0x11223344)
        XCTAssertEqual(UInt32.fromBytes([0x11, 0x22, 0x33]), 0x00112233)
        XCTAssertEqual(UInt32.fromBytes([0x11]), 0x00000011)
    }
    
    func testSetAndCheckBits() {
        var value = 0x00 as UInt8
        value[7] = true
        XCTAssertFalse(value[0])
        XCTAssertEqual(value, 0x80)
        
        value[0] = true
        value[7] = false
        XCTAssertTrue(value[0])
        XCTAssertFalse(value[7])
        XCTAssertEqual(value, 0x01)
    }
}
