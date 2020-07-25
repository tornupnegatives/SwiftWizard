import Foundation

/// Methods for converting between binary, hex, and integers
struct BitHelpers {
    static func valueToBinary(value: Int, nBits: Int) -> String {
        let binary: String = String(value, radix: 2)
        return leftZeroPad(binary: binary, nBits: nBits)
    }
    
    static func binaryToValue(binary: String) -> Int {
        return Int(binary, radix: 2)!
    }
    
    static func byteToValue(byte: String) -> Int {
        let parsed: UInt = strtoul(byte, nil, 16)   // sscanf(byte, "%x", &parsed)
        return Int(parsed)
    }
    
    private static func leftZeroPad(binary: String, nBits: Int) -> String {
        var padded: String = binary
        
        while padded.count < nBits {
            padded = "0" + padded
        }
        return padded
    }
}
