// 

import Foundation

final class NibbleSwitcher {
    static func process(nibbles: [String]) -> [String] {
        var switched: [String] = [String]()
        
        for nibble in nibbles {
            let offset: Int = (nibble.count == 4) ? 2 : 0
            
            let index: String.Index = nibble.index(nibble.startIndex, offsetBy: 1 + offset)
            let leftByte: String = String(nibble[..<index])
            let rightByte: String = String(nibble[index...])
            
            let switchedNibble: String = rightByte + leftByte
            switched.append(switchedNibble)
        }
        return switched
    }
}
