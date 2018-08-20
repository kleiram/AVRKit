import Foundation

class Program {
    private var memory: Memory
    
    init(memory: Memory) {
        self.memory = memory
    }
    
    subscript(index: Int) -> UInt16 {
        get { return self.memory[index * 2] }
        set { self.memory[index * 2] = newValue }
    }
}
