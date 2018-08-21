import Foundation

class HexLoader {
    typealias Record = (Int, Int, RecordType, [UInt8])
    
    enum RecordType: Int {
        case Data = 0
        case EndOfFile = 1
    }
    
    public func load(_ file: String, core: Core) {
        let data = try! String(contentsOfFile: file)
        
        data.components(separatedBy: .newlines)
            .filter { line in line.count > 0 }
            .forEach { line in program(line, core: core) }
    }
    
    private func program(_ line: String, core: Core) {
        let record = parse(line: line)
        
        if (record.2 == .Data) {
            record.3.enumerated().forEach { (offset, element) in
                core.flash[record.1 + offset] = element
            }
        }
    }
    
    private func parse(line: String) -> Record {
        let matches = match(line: line)
        
        return (
            Int(matches[0], radix: 16)!,
            Int(matches[1], radix: 16)!,
            RecordType(rawValue: Int(matches[2], radix: 16)!)!,
            bytes(bytes: matches[3])
        )
    }
    
    private func match(line: String) -> [Substring] {
        let pattern = ":([a-fA-F0-9]{2})([A-Fa-f0-9]{4})([A-Fa-f0-9]{2})([A-Fa-f0-9]*)([A-Fa-f0-9]{2})"
        
        let groups  = ["count", "address", "type", "data", "checksum"]
        let regex   = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: line, options: [], range: NSRange(location: 0, length: line.count))
        
        return groups.enumerated().map({ (offset, element) -> Substring in
            let match = matches[0].range(at: offset + 1)
            let start = String.Index(encodedOffset: match.location)
            let end   = String.Index(encodedOffset: match.location + match.length)
            
            return line[start..<end]
        })
    }
    
    private func bytes(bytes: Substring) -> [UInt8] {
        let pattern = "([A-Fa-f0-9]{2})"

        let regex   = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: String(bytes), options: [], range: NSRange(location: 0, length: bytes.count))
        
        return matches.map({ match -> Substring in
            let start = String.Index(encodedOffset: bytes.startIndex.encodedOffset + match.range.location)
            let end   = String.Index(encodedOffset: bytes.startIndex.encodedOffset + match.range.location + match.range.length)
            
            return bytes[start..<end]
        }).map({ substring in
            return UInt8(substring, radix: 16)!
        })
    }
}
