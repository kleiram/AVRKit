import XCTest
@testable import AVRKit

class DecoderTest: XCTestCase {
    var core    = Core(sram: 128, flash: 128, eeprom: 128)
    var decoder = Decoder()
    
    // MARK: - Arithmetic and logic
    
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
    
    // MARK: - Data Transfer
    
    func testMov() {
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xaa as UInt8
        decoder.decode(opcode: 0x2c01, core: core)
        XCTAssertEqual(core.registers[0], 0xaa as UInt8)
    }
    
    func testMovw() {
        core.registers[2] = 0x11 as UInt8
        core.registers[3] = 0x22 as UInt8
        decoder.decode(opcode: 0x0101, core: core)
        XCTAssertEqual(core.registers[0], 0x11 as UInt8)
        XCTAssertEqual(core.registers[1], 0x22 as UInt8)
    }
    
    func testLdi() {
        core.registers[16] = 0 as UInt8
        decoder.decode(opcode: 0xee0f, core: core)
        XCTAssertEqual(core.registers[16], 0xef as UInt8)
    }
    
    func testLds() {
        core.sram[127]  = 0xff as UInt8
        core.program[1] = 223
        decoder.decode(opcode: 0x9000, core: core)
        XCTAssertEqual(core.registers[0], 0xff as UInt8)
    }
    
    func testLd() {
        core.x         = 223
        core.sram[127] = 0xff as UInt8
        decoder.decode(opcode: 0x900c, core: core)
        XCTAssertEqual(core.x, 223)
        XCTAssertEqual(core.registers[0], 0xff as UInt8)
        
        core.x         = 223
        core.sram[127] = 0xee as UInt8
        decoder.decode(opcode: 0x900d, core: core)
        XCTAssertEqual(core.x, 224)
        XCTAssertEqual(core.registers[0], 0xee as UInt8)
        
        core.x         = 224
        core.sram[127] = 0xdd as UInt8
        decoder.decode(opcode: 0x900e, core: core)
        XCTAssertEqual(core.x, 223)
        XCTAssertEqual(core.registers[0], 0xdd as UInt8)
        
        core.y         = 223
        core.sram[127] = 0xcc as UInt8
        decoder.decode(opcode: 0x8008, core: core)
        XCTAssertEqual(core.y, 223)
        XCTAssertEqual(core.registers[0], 0xcc as UInt8)
        
        core.y         = 223
        core.sram[127] = 0xbb as UInt8
        decoder.decode(opcode: 0x9009, core: core)
        XCTAssertEqual(core.y, 224)
        XCTAssertEqual(core.registers[0], 0xbb as UInt8)
        
        core.y         = 224
        core.sram[127] = 0xaa as UInt8
        decoder.decode(opcode: 0x900a, core: core)
        XCTAssertEqual(core.y, 223)
        XCTAssertEqual(core.registers[0], 0xaa as UInt8)
        
        core.z         = 223
        core.sram[127] = 0x99 as UInt8
        decoder.decode(opcode: 0x8000, core: core)
        XCTAssertEqual(core.z, 223)
        XCTAssertEqual(core.registers[0], 0x99 as UInt8)
        
        core.z         = 223
        core.sram[127] = 0x88 as UInt8
        decoder.decode(opcode: 0x9001, core: core)
        XCTAssertEqual(core.z, 224)
        XCTAssertEqual(core.registers[0], 0x88 as UInt8)
        
        core.z         = 224
        core.sram[127] = 0x77 as UInt8
        decoder.decode(opcode: 0x9002, core: core)
        XCTAssertEqual(core.z, 223)
        XCTAssertEqual(core.registers[0], 0x77 as UInt8)
    }
    
    func testLdd() {
        core.y         = 219
        core.sram[127] = 0xff as UInt8
        decoder.decode(opcode: 0x800c, core: core)
        XCTAssertEqual(core.y, 219)
        XCTAssertEqual(core.registers[0], 0xff as UInt8)
        
        core.z         = 219
        core.sram[127] = 0xee as UInt8
        decoder.decode(opcode: 0x8004, core: core)
        XCTAssertEqual(core.z, 219)
        XCTAssertEqual(core.registers[0], 0xee as UInt8)
    }
    
    func testSts() {
        core.registers[0] = 0xff as UInt8
        core.program[1]   = 223 as UInt16
        decoder.decode(opcode: 0x9200, core: core)
        XCTAssertEqual(core.sram[127], 0xff as UInt8)
    }
    
    func testSt() {
        core.x            = 223
        core.registers[0] = 0xff as UInt8
        decoder.decode(opcode: 0x920c, core: core)
        XCTAssertEqual(core.x, 223)
        XCTAssertEqual(core.sram[127], 0xff as UInt8)
        
        core.x            = 223
        core.registers[0] = 0xee as UInt8
        decoder.decode(opcode: 0x920d, core: core)
        XCTAssertEqual(core.x, 224)
        XCTAssertEqual(core.sram[127], 0xee as UInt8)
        
        core.x            = 224
        core.registers[0] = 0xdd as UInt8
        decoder.decode(opcode: 0x920e, core: core)
        XCTAssertEqual(core.x, 223)
        XCTAssertEqual(core.sram[127], 0xdd as UInt8)
        
        core.y            = 223
        core.registers[0] = 0xcc as UInt8
        decoder.decode(opcode: 0x8208, core: core)
        XCTAssertEqual(core.y, 223)
        XCTAssertEqual(core.sram[127], 0xcc as UInt8)
        
        core.y            = 223
        core.registers[0] = 0xbb as UInt8
        decoder.decode(opcode: 0x9209, core: core)
        XCTAssertEqual(core.y, 224)
        XCTAssertEqual(core.sram[127], 0xbb as UInt8)
        
        core.y            = 224
        core.registers[0] = 0xaa as UInt8
        decoder.decode(opcode: 0x920a, core: core)
        XCTAssertEqual(core.y, 223)
        XCTAssertEqual(core.sram[127], 0xaa as UInt8)
        
        core.z            = 223
        core.registers[0] = 0x99 as UInt8
        decoder.decode(opcode: 0x8200, core: core)
        XCTAssertEqual(core.z, 223)
        XCTAssertEqual(core.sram[127], 0x99 as UInt8)
        
        core.z            = 223
        core.registers[0] = 0x88 as UInt8
        decoder.decode(opcode: 0x9201, core: core)
        XCTAssertEqual(core.z, 224)
        XCTAssertEqual(core.sram[127], 0x88 as UInt8)
        
        core.z            = 224
        core.registers[0] = 0x77 as UInt8
        decoder.decode(opcode: 0x9202, core: core)
        XCTAssertEqual(core.z, 223)
        XCTAssertEqual(core.sram[127], 0x77 as UInt8)
    }
    
    func testStd() {
        core.y            = 219
        core.registers[0] = 0xfe as UInt8
        decoder.decode(opcode: 0x820c, core: core)
        XCTAssertEqual(core.y, 219)
        XCTAssertEqual(core.sram[127], 0xfe as UInt8)
        
        core.z            = 219
        core.registers[0] = 0xdc as UInt8
        decoder.decode(opcode: 0x8204, core: core)
        XCTAssertEqual(core.z, 219)
        XCTAssertEqual(core.sram[127], 0xdc as UInt8)
    }
    
    func testIn() {
        core.io[31] = 0xab as UInt8
        decoder.decode(opcode: 0xb20f, core: core)
        XCTAssertEqual(core.registers[0], 0xab as UInt8)
    }
    
    func testOut() {
        core.registers[0] = 0xba as UInt8
        decoder.decode(opcode: 0xba0f, core: core)
        XCTAssertEqual(core.io[31], 0xba as UInt8)
    }
    
    func testPush() {
        core.registers[0] = 0xaa as UInt8
        decoder.decode(opcode: 0x920f, core: core)
        XCTAssertEqual(core.sp, 222)
        XCTAssertEqual(core.sram[127], 0xaa as UInt8)
    }
    
    func testPop() {
        core.sp        = 222
        core.sram[127] = 0xbb as UInt8
        decoder.decode(opcode: 0x900f, core: core)
        XCTAssertEqual(core.sp, 223)
        XCTAssertEqual(core.registers[0], 0xbb as UInt8)
    }
    
    func testXch() {
        core.z            = 223
        core.sram[127]    = 0xcc as UInt8
        core.registers[1] = 0xdd as UInt8
        decoder.decode(opcode: 0x9214, core: core)
        XCTAssertEqual(core.sram[127], 0xdd as UInt8)
        XCTAssertEqual(core.registers[1], 0xcc as UInt8)
    }
    
    // MARK: Branching
    
    func testJmp() {
        core.program[1] = 3 as UInt16
        decoder.decode(opcode: 0x940c, core: core)
        XCTAssertEqual(core.pc, 3)
    }
    
    func testRjmp() {
        core.pc = 100
        decoder.decode(opcode: 0xcffe, core: core)
        XCTAssertEqual(core.pc, 99)
        
        core.pc = 100
        decoder.decode(opcode: 0xc001, core: core)
        XCTAssertEqual(core.pc, 102)
    }
    
    func testIjmp() {
        core.z  = 20
        core.pc = 100
        decoder.decode(opcode: 0x9409, core: core)
        XCTAssertEqual(core.pc, 20)
    }
    
    func testCall() {
        core.sp         = 223
        core.pc         = 3
        core.program[4] = 200
        decoder.decode(opcode: 0x940e, core: core)
        XCTAssertEqual(core.sp, 221)
        XCTAssertEqual(core.pc, 200)
        XCTAssertEqual(core.sram[127], 0 as UInt8)
        XCTAssertEqual(core.sram[126], 5 as UInt8)
        
        core.sp         = 223
        core.pc         = 3
        core.pcSize     = .Bit22
        core.program[4] = 200
        decoder.decode(opcode: 0x940e, core: core)
        XCTAssertEqual(core.sp, 220)
        XCTAssertEqual(core.pc, 200)
        XCTAssertEqual(core.sram[127], 0 as UInt8)
        XCTAssertEqual(core.sram[126], 0 as UInt8)
        XCTAssertEqual(core.sram[125], 5 as UInt8)
    }
    
    func testRcall() {
        core.pc = 100
        decoder.decode(opcode: 0xdffe, core: core)
        XCTAssertEqual(core.pc, 99)
        XCTAssertEqual(core.sp, 221)
        XCTAssertEqual(core.sram[127], 0 as UInt8)
        XCTAssertEqual(core.sram[126], 101 as UInt8)
    }
    
    func testIcall() {
        core.z  = 200
        core.pc = 100
        decoder.decode(opcode: 0x9509, core: core)
        XCTAssertEqual(core.pc, 200)
        XCTAssertEqual(core.sp, 221)
        XCTAssertEqual(core.sram[127], 0 as UInt8)
        XCTAssertEqual(core.sram[126], 101 as UInt8)
    }
    
    func testRet() {
        core.pc        = 200
        core.sp        = 221
        core.sram[127] = 1 as UInt8
        core.sram[126] = 0 as UInt8
        decoder.decode(opcode: 0x9508, core: core)
        XCTAssertEqual(core.sp, 223)
        XCTAssertEqual(core.pc, 256)
    }
    
    func testReti() {
        core.pc        = 200
        core.sp        = 221
        core.sram[127] = 1 as UInt8
        core.sram[126] = 0 as UInt8
        decoder.decode(opcode: 0x9518, core: core)
        XCTAssertEqual(core.sp, 223)
        XCTAssertEqual(core.pc, 256)
        XCTAssertTrue(core.sreg.i)
    }
    
    func testCpse() {
        core.pc           = 10
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xee as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 11)
        
        core.pc           = 10
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xff as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 12)
        
        core.pc           = 10
        core.program[11]  = 0x940c
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xff as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 13)
    }
    
    func testCp() {
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xfe as UInt8
        decoder.decode(opcode: 0x1401, core: core)
        XCTAssertFalse(core.sreg.z)
        
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xff as UInt8
        decoder.decode(opcode: 0x1401, core: core)
        XCTAssertTrue(core.sreg.z)
    }
    
    func testCpc() {
        core.sreg.c       = false
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xfe as UInt8
        decoder.decode(opcode: 0x0401, core: core)
        XCTAssertFalse(core.sreg.z)
        
        core.sreg.c       = true
        core.registers[0] = 0xff as UInt8
        core.registers[1] = 0xfe as UInt8
        decoder.decode(opcode: 0x0401, core: core)
        XCTAssertTrue(core.sreg.z)
    }
    
    func testCpi() {
        core.registers[16] = 0xff as UInt8
        decoder.decode(opcode: 0x3f0e, core: core)
        XCTAssertFalse(core.sreg.z)
        
        core.registers[16] = 0xff as UInt8
        decoder.decode(opcode: 0x3f0f, core: core)
        XCTAssertTrue(core.sreg.z)
    }
    
    func testSbrc() {
        core.pc           = 5
        core.registers[0] = 0xff as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 6)
        
        core.pc           = 5
        core.registers[0] = 0x00 as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 7)
        
        core.pc           = 5
        core.program[6]   = 0x940c
        core.registers[0] = 0x00 as UInt8
        decoder.decode(opcode: 0x1001, core: core)
        XCTAssertEqual(core.pc, 8)
    }
    
    func testSbrs() {
        core.pc           = 5
        core.registers[0] = 0x00 as UInt8
        decoder.decode(opcode: 0xfe07, core: core)
        XCTAssertEqual(core.pc, 6)
        
        core.pc           = 5
        core.registers[0] = 0xff as UInt8
        decoder.decode(opcode: 0xfe07, core: core)
        XCTAssertEqual(core.pc, 7)
        
        core.pc           = 5
        core.program[6]   = 0x940c
        core.registers[0] = 0xff as UInt8
        decoder.decode(opcode: 0xfe07, core: core)
        XCTAssertEqual(core.pc, 8)
    }
    
    func testSbic() {
        core.pc         = 5
        core.io[0]      = 0xff as UInt8
        core.program[6] = 0x0000
        decoder.decode(opcode: 0x9907, core: core)
        XCTAssertEqual(core.pc, 6)
        
        core.pc         = 5
        core.io[0]      = 0x00 as UInt8
        core.program[6] = 0x0000
        decoder.decode(opcode: 0x9907, core: core)
        XCTAssertEqual(core.pc, 7)
        
        core.pc         = 5
        core.io[0]      = 0x00 as UInt8
        core.program[6] = 0x940c
        decoder.decode(opcode: 0x9907, core: core)
        XCTAssertEqual(core.pc, 8)
    }
    
    func testSbis() {
        core.pc         = 5
        core.io[0]      = 0x00 as UInt8
        core.program[6] = 0x0000
        decoder.decode(opcode: 0x9b07, core: core)
        XCTAssertEqual(core.pc, 6)
        
        core.pc         = 5
        core.io[0]      = 0xff as UInt8
        core.program[6] = 0x0000
        decoder.decode(opcode: 0x9b07, core: core)
        XCTAssertEqual(core.pc, 7)
        
        core.pc         = 5
        core.io[0]      = 0xff as UInt8
        core.program[6] = 0x940c
        decoder.decode(opcode: 0x9b07, core: core)
        XCTAssertEqual(core.pc, 8)
    }
    
    func testBrbs() {
        core.pc     = 5
        core.sreg.c = true
        decoder.decode(opcode: 0xf3e0, core: core)
        XCTAssertEqual(core.pc, 2)
        
        core.pc     = 5
        core.sreg.c = false
        decoder.decode(opcode: 0xf3e0, core: core)
        XCTAssertEqual(core.pc, 6)
    }
    
    func testBrbc() {
        core.pc     = 5
        core.sreg.c = false
        decoder.decode(opcode: 0xf7e0, core: core)
        XCTAssertEqual(core.pc, 2)
        
        core.pc     = 5
        core.sreg.c = true
        decoder.decode(opcode: 0xf7e0, core: core)
        XCTAssertEqual(core.pc, 6)
    }
    
    // MARK: Bit and Bit-test
    
    func testLsr() {
        core.registers[0] = 0x11 as UInt8
        decoder.decode(opcode: 0x9406, core: core)
        XCTAssertEqual(core.registers[0], 0x08 as UInt8)
        
        core.registers[0] = 0x88 as UInt8
        decoder.decode(opcode: 0x9406, core: core)
        XCTAssertEqual(core.registers[0], 0x44 as UInt8)
    }
    
    func testRor() {
        core.sreg.c       = true
        core.registers[0] = 0x82 as UInt8
        decoder.decode(opcode: 0x9407, core: core)
        XCTAssertEqual(core.registers[0], 0xc1 as UInt8)
    }
    
    func testAsr() {
        core.registers[0] = 0x88 as UInt8
        decoder.decode(opcode: 0x9405, core: core)
        XCTAssertEqual(core.registers[0], 0xc4 as UInt8)
        
        core.registers[0] = 0x44 as UInt8
        decoder.decode(opcode: 0x9405, core: core)
        XCTAssertEqual(core.registers[0], 0x22 as UInt8)
    }
    
    func testSwap() {
        core.registers[0] = 0xf0 as UInt8
        decoder.decode(opcode: 0x9402, core: core)
        XCTAssertEqual(core.registers[0], 0x0f as UInt8)
    }
    
    func testSbi() {
        core.io[0] = 0x00 as UInt8
        decoder.decode(opcode: 0x9a07, core: core)
        XCTAssertEqual(core.io[0], 0x80 as UInt8)
    }
    
    func testCbi() {
        core.io[0] = 0xff as UInt8
        decoder.decode(opcode: 0x9807, core: core)
        XCTAssertEqual(core.io[0], 0x7f as UInt8)
    }
    
    func testBst() {
        core.registers[0] = 0x80 as UInt8
        decoder.decode(opcode: 0xfa07, core: core)
        XCTAssertTrue(core.sreg.t)
        
        core.registers[0] = 0x00 as UInt8
        decoder.decode(opcode: 0xfa07, core: core)
        XCTAssertFalse(core.sreg.t)
    }
    
    func testBld() {
        core.sreg.t       = true
        core.registers[0] = 0x00 as UInt8
        decoder.decode(opcode: 0xf807, core: core)
        XCTAssertEqual(core.registers[0], 0x80 as UInt8)
        
        core.sreg.t       = false
        core.registers[0] = 0xff as UInt8
        decoder.decode(opcode: 0xf807, core: core)
        XCTAssertEqual(core.registers[0], 0x7f as UInt8)
    }
    
    func testBset() {
        core.sreg.i = false
        decoder.decode(opcode: 0x9478, core: core)
        XCTAssertTrue(core.sreg.i)
    }
    
    func testBclr() {
        core.sreg.i = true
        decoder.decode(opcode: 0x94f8, core: core)
        XCTAssertFalse(core.sreg.i)
    }
    
    // MARK: MCU Control
    
    func testBreak() {
        decoder.decode(opcode: 0x9598, core: core)
        XCTAssertEqual(core.state, .Stopped)
    }
    
    func testSleep() {
        decoder.decode(opcode: 0x9588, core: core)
        XCTAssertEqual(core.state, .Sleeping)
    }
}
