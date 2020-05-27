// BitHelpers provides some static methods for working with binary strings

import Foundation

final class BitHelpers {
    // Originally valueToBinary()
    static func intToBin(int: UInt, nBits: UInt) -> String {
        var int = int
        var binary: String = ""
        
        repeat {
            binary = String(format: "%lu", int & 1) + binary
            int >>= 1
        } while int > 0
        
        return leftZeroPadded(binary: binary, nBits: nBits)
    }
    
    private static func leftZeroPadded(binary: String, nBits: UInt) -> String {
        var binary: String = binary
        
        while binary.count < nBits {
            binary = "0\(binary)"
        }
        return binary
    }
    
    // Originally valueForBinary()
    static func binToInt(binary: String) -> UInt {
        var int: UInt = 0
        let cString: String = String(describing: binary.cString(using: String.Encoding.utf8)) // Thanks alessandro-ornano
        let length = cString.count
        
        for offset in length...0 {
            if cString[cString.index(cString.startIndex, offsetBy: offset)] == "1" {
                int += (1 << abs(offset - length))
            }
        }
        return int
    }
    
    static func byteToInt(byte: String) -> UInt {
        return UInt(byte) ?? 0  // TODO: TEST
    }
    
}
