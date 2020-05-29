// BitHelpers provides some static methods for working with binary strings

import Foundation

final class BitHelpers {
    static func valueToBinary(int: UInt, nBits: UInt) -> String {
        let binary: String = String(int, radix: 2)
        return leftZeroPad(binary: binary, nBits: nBits)
    }
    
    private static func leftZeroPad(binary: String, nBits: UInt) -> String {
        var padded: String = binary
        
        while padded.count < nBits {
            padded = "0" + padded
        }
        return padded
    }
    
    static func binaryToValue(binary: String) -> UInt {
        return UInt(binary, radix: 2) ?? 0
    }
    
    static func byteToValue(byte: String) -> UInt {
        return UInt(byte) ?? 0
    }
    
}
