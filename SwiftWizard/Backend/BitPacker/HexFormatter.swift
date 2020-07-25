// The HexFormatter is used to create Arduino-style bytestreams that include a hex prefix ("0x")

import Foundation

final class HexFormatter {
    static func process(nibbles: [String]) -> [String] {
        if !UserSettings.sharedInstance.includeHexPrefix {
            return nibbles
        }
        var nibblesWithPrefixes: [String] = []
        for nibble: String in nibbles {
            let withPrefix: String = "0x\(nibble)"
            nibblesWithPrefixes.append(withPrefix)
        }
        return nibblesWithPrefixes
    }
}
