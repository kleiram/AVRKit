import Foundation

class Memory {
    public var data: [UInt8]
    
    init(count: Int) {
        self.data = [UInt8](repeating: 0, count: count)
    }
    
    subscript(index: Int) -> UInt8 {
        get {
            return data[index]
        }
        set {
            data[index] = newValue
        }
    }
    
    subscript(index: Int) -> UInt16 {
        get {
            return UInt16(data[index + 1]) << 8 | UInt16(data[index])
        }
        set {
            data[index] = UInt8(newValue & 0xff)
            data[index + 1] = UInt8(newValue >> 8)
        }
    }
}

extension Memory {
    class Proxy: Memory {
        private var memory: Memory
        private var offset: Int
        
        init(memory: Memory, offset: Int) {
            self.memory = memory
            self.offset = offset
            
            super.init(count: 0)
        }
        
        override subscript(index: Int) -> UInt8 {
            get {
                return memory[offset + index]
            }
            set {
                memory[offset + index] = newValue
            }
        }
        
        override subscript(index: Int) -> UInt16 {
            get {
                let Rl: UInt8 = memory[offset + index]
                let Rh: UInt8 = memory[offset + index + 1]
                
                return UInt16(Rh) << 8 | UInt16(Rl)
            }
            set {
                memory[offset + index] = UInt8(newValue & 0xff)
                memory[offset + index + 1] = UInt8(newValue >> 8)
            }
        }
    }
}
