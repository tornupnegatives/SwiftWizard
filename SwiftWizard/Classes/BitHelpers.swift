// BitHelpers provides some static methods for working with binary strings

import Foundation

final class BitHelpers {
    static func valueToBinary(value: Int, nBits: Int) -> String {
        let binary: String = String(value, radix: 2)
        return leftZeroPad(binary: binary, nBits: nBits)
    }
    
    private static func leftZeroPad(binary: String, nBits: Int) -> String {
        var padded: String = binary
        
        while padded.count < nBits {
            padded = "0" + padded
        }
        return padded
    }
    
    static func binaryToValue(binary: String) -> Int {
        return Int(binary, radix: 2) ?? 0
    }
    
    static func byteToValue(byte: String) -> Int {
        return Int(byte) ?? 0
    }
    
}
