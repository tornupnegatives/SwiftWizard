// BitHelpers provides some static methods for working with binary strings

import Foundation

enum BitHelpersError: Error {
    case illegalByte(String)
}

final class BitHelpers {
    // Converts passed Int to its binary representation
    static func valueToBinary(value: Int, nBits: Int) -> String {
        let binary: String = String(value, radix: 2)
        return leftZeroPad(binary: binary, nBits: nBits)
    }
    
    // Converts passed binary string to an Int
    static func binaryToValue(binary: String) -> Int {
        return Int(binary, radix: 2) ?? 0
    }
    
    // Converts passed byte string to an Int
    static func byteToValue(byte: String) throws -> Int {
        guard let newByte = Int(byte) else {
            throw BitHelpersError.illegalByte("Invalid byte \'\(byte)\'")
        }
        return newByte
    }
    
    private static func leftZeroPad(binary: String, nBits: Int) -> String {
        var padded: String = binary
        
        while padded.count < nBits {
            padded = "0" + padded
        }
        return padded
    }
}
