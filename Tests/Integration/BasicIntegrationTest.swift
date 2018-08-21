import XCTest
@testable import AVRKit

class BasicIntegrationTest: XCTestCase {
    let core    = Core(sram: 128, flash: 128, eeprom: 128)
    let decoder = Decoder()
    
    private var fixture: String {
        get {
            return Bundle(for: type(of: self)).path(forResource: "Test", ofType: "hex")!
        }
    }
    
    func test() {
        let loader = HexLoader()
        loader.load(fixture, core: core)
        
        while core.state != .Stopped {
            decoder.decode(opcode: core.program[Int(core.pc)], core: core)
        }
        
        XCTAssertEqual(core.registers[16], 10 as UInt8)
    }
}
