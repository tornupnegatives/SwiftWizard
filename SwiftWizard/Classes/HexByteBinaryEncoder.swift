// The HexByteBinaryEncoder parses hex bitstreams into a binary format acceptable to the TMS5220

import Foundation

final class HexByteBinaryEncoder {
    static func process(hexNibbles: [String]) -> [String] {
        var binary: [String] = [String]()
        
        for nibble in hexNibbles {
            let leftByte: String = String(Array(nibble)[0])
            
            // There is no right bit
            if hexNibbles.count == 1 {
                binary.append("0000")
                binary.append(binaryForByte(byte: leftByte))
                
            // Right and left bit
            } else {
                let rightByte: String = String(Array(nibble)[1])
                binary.append(binaryForByte(byte: leftByte))
                binary.append(binaryForByte(byte: rightByte))
            }
        }
        return binary
    }
    
    private static func binaryForByte(byte: String) -> String {
        var value: Int
        
        do {
            value = try BitHelpers.byteToValue(byte: byte)
        } catch BitHelpersError.illegalByte(byte) {
            return "0000"
        } catch {
            return "0000"
        }
        return BitHelpers.valueToBinary(value: value, nBits: 4)
    }
}
