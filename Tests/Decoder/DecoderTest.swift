import XCTest
@testable import AVRKit

class DecoderTest: XCTestCase {
    var core    = Core(sram: 128, flash: 128, eeprom: 128)
    var decoder = Decoder()
    
    // MARK: Arithmetic and logic
    
    func testAdc() {
        core.sreg.c       = false
        core.registers[0] = 1 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x1c01, core: core)
        XCTAssertEqual(core.registers[0], 2 as UInt8)
        
        core.sreg.c       = true
        core.registers[0] = 1 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x1c01, core: core)
        XCTAssertEqual(core.registers[0], 3 as UInt8)
    }
    
    func testAdd() {
        core.registers[0] = 1 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x0c01, core: core)
        XCTAssertEqual(core.registers[0], 2 as UInt8)
    }
    
    func testAdiw() {
        core.registers[24] = 255 as UInt8
        core.registers[25] = 0 as UInt8
        decoder.decode(opcode: 0x9601, core: core)
        XCTAssertEqual(core.registers[24], 0 as UInt8)
        XCTAssertEqual(core.registers[25], 1 as UInt8)
    }
    
    func testSub() {
        core.registers[0] = 2 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x1801, core: core)
        XCTAssertEqual(core.registers[0], 1 as UInt8)
    }
    
    func testSubi() {
        core.registers[16] = 2 as UInt8
        decoder.decode(opcode: 0x5001, core: core)
        XCTAssertEqual(core.registers[16], 1 as UInt8)
    }
    
    func testSbc() {
        core.sreg.c       = false
        core.registers[0] = 2 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x0801, core: core)
        XCTAssertEqual(core.registers[0], 1 as UInt8)
        
        core.sreg.c       = true
        core.registers[0] = 2 as UInt8
        core.registers[1] = 1 as UInt8
        decoder.decode(opcode: 0x0801, core: core)
        XCTAssertEqual(core.registers[0], 0 as UInt8)
    }
    
    func testSbci() {
        core.sreg.c        = false
        core.registers[16] = 2 as UInt8
        decoder.decode(opcode: 0x4001, core: core)
        XCTAssertEqual(core.registers[16], 1 as UInt8)
        
        core.sreg.c        = true
        core.registers[16] = 2 as UInt8
        decoder.decode(opcode: 0x4001, core: core)
        XCTAssertEqual(core.registers[16], 0 as UInt8)
    }
    
    func testSbiw() {
        core.registers[24] = 0 as UInt8
        core.registers[25] = 1 as UInt8
        decoder.decode(opcode: 0x9701, core: core)
        XCTAssertEqual(core.registers[24], 255 as UInt8)
        XCTAssertEqual(core.registers[25], 0 as UInt8)
    }
    
    func testAnd() {
        core.registers[0] = 0x05 as UInt8
        core.registers[1] = 0x03 as UInt8
        decoder.decode(opcode: 0x2001, core: core)
        XCTAssertEqual(core.registers[0], 0x01 as UInt8)
    }
    
    func testAndi() {
        core.registers[16] = 0x05 as UInt8
        decoder.decode(opcode: 0x7003, core: core)
        XCTAssertEqual(core.registers[16], 0x01 as UInt8)
    }
    
    func testOr() {
        core.registers[0] = 0x0f as UInt8
        core.registers[1] = 0xf0 as UInt8
        decoder.decode(opcode: 0x2801, core: core)
        XCTAssertEqual(core.registers[0], 0xff as UInt8)
    }
    
    func testOri() {
        core.registers[16] = 0x0f as UInt8
        decoder.decode(opcode: 0x6f00, core: core)
        XCTAssertEqual(core.registers[16], 0xff as UInt8)
    }
    
    func testEor() {
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0x0f as UInt8
        decoder.decode(opcode: 0x2401, core: core)
        XCTAssertEqual(core.registers[0], 0xf0 as UInt8)
    }
    
    func testCom() {
        core.registers[0] = 1 as UInt8
        decoder.decode(opcode: 0x9400, core: core)
        XCTAssertEqual(core.registers[0], 0xfe as UInt8)
    }
    
    func testNeg() {
        core.registers[0] = 1 as UInt8
        decoder.decode(opcode: 0x9401, core: core)
        XCTAssertEqual(core.registers[0], 0xff as UInt8)
    }
    
    func testInc() {
        core.registers[0] = 1 as UInt8
        decoder.decode(opcode: 0x9403, core: core)
        XCTAssertEqual(core.registers[0], 2 as UInt8)
    }
    
    func testDec() {
        core.registers[0] = 1 as UInt8
        decoder.decode(opcode: 0x940a, core: core)
        XCTAssertEqual(core.registers[0], 0 as UInt8)
    }
    
    func testSer() {
        core.registers[16] = 0 as UInt8
        decoder.decode(opcode: 0xef0f, core: core)
        XCTAssertEqual(core.registers[16], 0xff as UInt8)
    }
    
    func testMul() {
        core.registers[0] = 0x80 as UInt8
        core.registers[1] = 0x02 as UInt8
        decoder.decode(opcode: 0x9c01, core: core)
        XCTAssertEqual(core.registers[0], 0 as UInt8)
        XCTAssertEqual(core.registers[1], 1 as UInt8)
    }
    
    func testMuls() {
        core.registers[16] = UInt8(bitPattern: -2)
        core.registers[17] = UInt8(bitPattern: -3)
        decoder.decode(opcode: 0x0201, core: core)
        XCTAssertEqual(core.registers[0], 6 as UInt8)
        XCTAssertEqual(core.registers[1], 0 as UInt8)
    }
    
    func testMulsu() {
        core.registers[16] = UInt8(bitPattern: -2)
        core.registers[17] = 255 as UInt8
        decoder.decode(opcode: 0x0301, core: core)
        XCTAssertEqual(core.registers[0], 0x02 as UInt8)
        XCTAssertEqual(core.registers[1], 0xfe as UInt8)
    }
}
