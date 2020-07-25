//

import Foundation

final class NibbleBitReverser {
    static func process(nibbles: [String]) -> [String] {
        var reversed: [String] = [String]()
        
        for nibble in nibbles {
            let substring:  String.Index = nibble.index(nibble.startIndex, offsetBy: 1)
            let leftByte:   String       = String(nibble.prefix(upTo: substring))
            let rightByte:  String       = (nibble.count == 1) ? "0" : String(nibble.suffix(from: substring))
            
            let reversedLeft:    Int    = reversedValueFor(byte: leftByte)
            let reversedRight:   Int    = reversedValueFor(byte: rightByte)
            let reversedNibble: String = String(format: "%x%x", reversedLeft, reversedRight)
            
            reversed.append(reversedNibble)
        }
        
        return reversed
    }
    
    /*

     +(NSUInteger)reversedValueFor:(NSString *)byte {
         NSUInteger value = [BitHelpers byteToValue:byte];
         NSString *binary = [BitHelpers valueToBinary:value bits:4];
         NSString *reversed = @"";
         const char *cString = [binary cStringUsingEncoding:NSUTF8StringEncoding];
         
         for (int i = 3; i >= 0; i--) {
             reversed = [reversed stringByAppendingString:[NSString stringWithFormat:@"%c", cString[i]]];
         }
         
         return [BitHelpers valueForBinary:reversed];
     }
    */
    
    // Reverses hex nibble
    private static func reversedValueFor(byte: String) -> Int {
        let value:  Int = BitHelpers.byteToValue(byte: byte)
        let binary: String = BitHelpers.valueToBinary(value: value, nBits: 4)
        
        var reversed: String = ""
        let cString:  [CChar] = binary.cString(using: String.Encoding.utf8)!
        
        var index: Int = 3
        while(index >= 0) {
            reversed += String(format: "%c", cString[index])
            index -= 1
        }
        
        return BitHelpers.binaryToValue(binary: reversed)
    }
}
