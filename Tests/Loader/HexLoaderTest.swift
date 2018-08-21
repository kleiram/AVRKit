import XCTest
@testable import AVRKit

class HexLoaderTest: XCTestCase {
    var core = Core(sram: 128, flash: 128, eeprom: 128)
    
    func testLoad() {
        let path = Bundle(for: type(of: self)).path(forResource: "Test", ofType: "hex")!
        let loader = HexLoader()
        loader.load(path, core: core)
        
        XCTAssertEqual(core.program[0], 0xe000)
        XCTAssertEqual(core.program[1], 0xe011)
        XCTAssertEqual(core.program[2], 0x0f01)
        XCTAssertEqual(core.program[3], 0x300a)
    }
}
