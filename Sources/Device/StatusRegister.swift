import Foundation

class StatusRegister {
    private var io: Memory
    
    public var c: Bool {
        get { return self[0] }
        set { self[0] = newValue }
    }
    
    public var z: Bool {
        get { return self[1] }
        set { self[1] = newValue }
    }
    
    public var n: Bool {
        get { return self[2] }
        set { self[2] = newValue }
    }
    
    public var v: Bool {
        get { return self[3] }
        set { self[3] = newValue }
    }
    
    public var s: Bool {
        get { return self[4] }
        set { self[4] = newValue }
    }
    
    public var h: Bool {
        get { return self[5] }
        set { self[5] = newValue }
    }
    
    public var t: Bool {
        get { return self[6] }
        set { self[6] = newValue }
    }
    
    public var i: Bool {
        get { return self[7] }
        set { self[7] = newValue }
    }
    
    init(io: Memory) {
        self.io = io
    }
    
    private subscript(index: Int) -> Bool {
        get {
            return (Bitset<UInt8>(io[63]))[index]
        }
        set {
            let bitset = Bitset<UInt8>(io[63])
            bitset[index] = newValue
            
            io[63] = bitset.value
        }
    }
}
