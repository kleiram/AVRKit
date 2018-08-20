import Foundation

extension FixedWidthInteger {
    subscript(index: Int) -> Bool {
        get {
            return (self & (1 << index)) != 0
        }
        set {
            self = newValue ? (self | (1 << index)) : (self & ~(1 << index))
        }
    }
    
    static func fromBytes(_ bytes: [UInt8]) -> Self {
        var resolved = bytes
        let length   = self.bitWidth / 8
        
        while (resolved.count < length) {
            resolved.insert(0, at: 0)
        }
        
        let elements = resolved[0...length - 1].reversed()
        var result   = Self()
        
        elements.enumerated().forEach { item in
            result = result | Self(item.element) << (item.offset * 8)
        }
        
        return result
    }
    
    func mask(_ mask: Self) -> Self {
        return (0...self.bitWidth - 1).reduce((Self(), 0), { result, i in
            let k: Int  = (mask & (1 << i)) != 0 ? result.1 + 1 : result.1
            let r: Self = (mask & (1 << i)) != 0 && (self & (1 << i)) != 0 ? result.0 | (1 << result.1) : result.0
            
            return (r, k)
        }).0;
    }
}
