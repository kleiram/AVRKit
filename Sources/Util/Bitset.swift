import Foundation

class Bitset<T: FixedWidthInteger> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    subscript(index: Int) -> Bool {
        get {
            return (value & T(1 << index)) != 0
        }
        set {
            value = newValue
                ? value | T(1 << index)
                : value & ~T(1 << index)
        }
    }
}
