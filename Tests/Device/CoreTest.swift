import XCTest
@testable import AVRKit

class CoreTest: XCTestCase {
    private var core: Core = Core(sram: 1024, flash: 1024, eeprom: 1024)

    func testOnDeviceMemory() {
        XCTAssertEqual(self.core.data.data.count, 1120)
        XCTAssertEqual(self.core.flash.data.count, 2048)
        XCTAssertEqual(self.core.eeprom.data.count, 1024)
    }
    
    func testMemoryMapping() {
        self.core.io[1] = UInt8(0xaa)
        self.core.sram[1] = UInt8(0xbb)
        self.core.registers[1] = UInt8(0xcc)
        
        XCTAssertEqual(self.core.data.data[1], 0xcc)
        XCTAssertEqual(self.core.data.data[33], 0xaa)
        XCTAssertEqual(self.core.data.data[97], 0xbb)
    }
    
    func testSpecialRegisters() {
        self.core.x = 0xbbaa
        self.core.y = 0xddcc
        self.core.z = 0xffee
        XCTAssertEqual(self.core.registers[31], UInt8(0xff))
        XCTAssertEqual(self.core.registers[30], UInt8(0xee))
        XCTAssertEqual(self.core.registers[29], UInt8(0xdd))
        XCTAssertEqual(self.core.registers[28], UInt8(0xcc))
        XCTAssertEqual(self.core.registers[27], UInt8(0xbb))
        XCTAssertEqual(self.core.registers[26], UInt8(0xaa))
        
        self.core.registers[31] = UInt8(0xaa)
        self.core.registers[30] = UInt8(0xbb)
        self.core.registers[29] = UInt8(0xcc)
        self.core.registers[28] = UInt8(0xdd)
        self.core.registers[27] = UInt8(0xee)
        self.core.registers[26] = UInt8(0xff)
        XCTAssertEqual(self.core.x, UInt16(0xeeff))
        XCTAssertEqual(self.core.y, UInt16(0xccdd))
        XCTAssertEqual(self.core.z, UInt16(0xaabb))
    }
    
    func testStackPointerAndProgramCount() {
        XCTAssertEqual(self.core.sp, 1119)
    }
    
    func test16BitProgramCounter() {
        self.core.pcSize = .Bit16
        XCTAssertEqual(self.core.pc, 0)
        
        self.core.pc = 0x10002
        XCTAssertEqual(3, self.core.pc)
    }
    
    func test22BitProgramCounter() {
        self.core.pcSize = .Bit22
        XCTAssertEqual(self.core.pc, 0)
        
        self.core.pc = 0x400002
        XCTAssertEqual(3, self.core.pc)
    }
    
    func testStatusRegister() {
        core.sreg.c = true
        core.sreg.n = true
        core.sreg.s = true
        core.sreg.t = true
        XCTAssertEqual(core.io[63], UInt8(0x55))
        
        core.io[63] = UInt8(0xaa)
        XCTAssertTrue(core.sreg.z)
        XCTAssertTrue(core.sreg.v)
        XCTAssertTrue(core.sreg.h)
        XCTAssertTrue(core.sreg.i)
        XCTAssertFalse(core.sreg.c)
        XCTAssertFalse(core.sreg.n)
        XCTAssertFalse(core.sreg.s)
        XCTAssertFalse(core.sreg.t)
    }
}
