// FrameDataBinaryEncoder provides some static methods for converting frames of parameters into binary

import Foundation

final class FrameDataBinaryEncoder {
    private static var binary: String = ""
    
    // Iterate through array of parameter dictionaries to get binary value for each element
    static func process(parameterList: [[String: Int]]) -> [String] {
        binary = ""
        
        for parameterPair in parameterList {
            for CTParameter in CodingTable.parameters {
                let index = CodingTable.parameters.firstIndex(of: CTParameter)! // top-level for-in guarantees it exists, safe to unwrap
                guard let value: Int = parameterPair[CTParameter] else {continue}
                
                let binaryValue: String = BitHelpers.valueToBinary(value: value, nBits: CodingTable.bits[index])
                binary += binaryValue
            }
        }
        return nibblesFrom(binary: binary)
    }
    
    // Take a long binary string and slice it into an array of four-digit binary "nibbles"
    private static func nibblesFrom(binary: String) -> [String] {
        var binary:  String   = binary
        var nibbles: [String] = [String]()
        
        while(binary.count >= 4) {
            let nibble: String = String(binary.prefix(4))
            let startSubString: String.Index = binary.index(binary.startIndex, offsetBy: 4)
            binary = String(binary[startSubString...])
            nibbles.append(nibble)
        }
        return nibbles
    }
}
