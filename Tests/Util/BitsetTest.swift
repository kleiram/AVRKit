import XCTest
@testable import AVRKit

class BitsetTest: XCTestCase {
    var bitset = Bitset<UInt8>(0)
    
    func testSetAndCheckBits() {
        bitset[7] = true
        XCTAssertEqual(bitset.value, 0x80)
        
        bitset[0] = true
        bitset[7] = false
        XCTAssertEqual(bitset.value, 0x01)
    }
}
