import XCTest
@testable import AVRKit

class MemoryTest: XCTestCase {
    private var memory = Memory(count: 128)

    func testByte() {
        memory[0] = UInt8(0xff)
        memory[1] = UInt8(0xee)
        
        XCTAssertEqual(memory[0], UInt8(0xff))
        XCTAssertEqual(memory[1], UInt8(0xee))
    }
    
    func testWord() {
        memory[0] = UInt8(0xff)
        memory[1] = UInt8(0xdd)
        memory[2] = UInt8(0xee)
        
        XCTAssertEqual(memory[0], UInt16(0xddff))
        XCTAssertEqual(memory[1], UInt16(0xeedd))
    }
}
