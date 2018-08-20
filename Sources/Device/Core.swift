import Foundation

class Core {
    enum ProgramCounterSize {
        case Bit16
        case Bit22
    }
    
    /// The on-device data memory.
    public var data: Memory
    
    /// The on-device flash memory.
    public var flash: Memory
    
    /// The on-device EEPROM memory.
    public var eeprom: Memory
    
    /// The on-device IO registers.
    public var io: Memory
    
    /// The on-device SRAM memory.
    public var sram: Memory
    
    /// The on-device general purpose registers.
    public var registers: Memory
    
    /// The status register of the core.
    public var sreg: StatusRegister
    
    /// The program flashed onto the core.
    public var program: Program
    
    /// The size of the program counter of the core.
    public var pcSize: ProgramCounterSize = .Bit16
    
    /// The special X-register of the core.
    public var x: UInt16 {
        get { return data[26] }
        set { data[26] = newValue }
    }
    
    /// The special Y-register of the core.
    public var y: UInt16 {
        get { return data[28] }
        set { data[28] = newValue }
    }
    
    /// The special Z-register of the core.
    public var z: UInt16 {
        get { return data[30] }
        set { data[30] = newValue }
    }
    
    /// The stack-pointer of the core.
    public var sp: UInt16 {
        get { return io[61] }
        set { io[61] = newValue >= data.data.count ? UInt16(data.data.count - 1) : newValue }
    }
    
    /// The program counter of the core.
    public var pc: UInt32 = 0 {
        didSet {
            if (pcSize == .Bit16 && pc > 0xffff) { pc = pc - 0xffff }
            if (pcSize == .Bit22 && pc > 0x3fffff) { pc = pc - 0x3fffff }
        }
    }
    
    /// Create a new device core.
    ///
    /// - Parameters:
    ///   - sram: The size of the on-device SRAM memory (in bytes).
    ///   - flash: The size of the on-device flash memory (in words).
    ///   - eeprom: The size of the on-device EEPROM memory (in bytes).
    public init(sram: Int, flash: Int, eeprom: Int) {
        self.data = Memory(count: sram + 96)
        self.flash = Memory(count: flash * 2)
        self.eeprom = Memory(count: eeprom)
        
        self.io = Memory.Proxy(memory: self.data, offset: 32)
        self.sram = Memory.Proxy(memory: self.data, offset: 96)
        self.registers = Memory.Proxy(memory: self.data, offset: 0)
        
        self.sreg    = StatusRegister(io: io)
        self.program = Program(memory: self.flash)
        self.sp      = UInt16(self.data.data.count - 1)
    }
}
