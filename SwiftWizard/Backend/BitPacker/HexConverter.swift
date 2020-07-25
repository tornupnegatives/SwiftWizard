// FINISH BITPACKER AND COME BACK
// TODO PROCESS() HEX DECLARED WITH = []

import Foundation

final class HexConverter {
    static let kHexChars: String = "0123456789ABCDEF"
    
    static func process(nibbles: [String]) -> [String] {
        var hex: [String] = []
        
        for nibble: String in nibbles {
            let value: Int = BitHelpers.binaryToValue(binary: nibble)
            let hexString: String = String(format: "%x", value)
            hex.append(hexString)
        }
        return inGroupsOfTwo(hex: hex)
    }
    
    private static func inGroupsOfTwo(hex: [String]) -> [String] {
        var grouped: [String] = []
        
        var idx: Int = 0
        var length: Int = hex.count
        while idx <= length - 2 {
            let group: String = "\(hex[idx])\(hex[idx + 1])"
            grouped.append(group)
            
            length = hex.count
            idx += 2
        }
        return grouped
    }
    
}

/*
 
 ALL BELOW ARE PUBLIC

 +(NSString *)stringFromData:(NSData *)data {
     NSUInteger bytesCount = [data length];
     if (!bytesCount) return @"";
     char delimiter = [[BitPacker delimiter] characterAtIndex:0];
     const unsigned char *dataBuffer = [data bytes];
     char *chars = malloc(sizeof(char) * (bytesCount * 3 + 1));
     char *s = chars;
     for (int i = 0; i < bytesCount; ++i) {
         *s++ = kHexChars[((*dataBuffer & 0xF0) >> 4)];
         *s++ = kHexChars[(*dataBuffer & 0x0F)];
         if (i < bytesCount - 1) *s++ = delimiter;
         dataBuffer++;
     }
     *s = kTerminator;
     NSString *hexString = [NSString stringWithUTF8String:chars];
     free(chars);
     return hexString;
 }

 +(NSData *)dataFromString:(NSString *)string {
     const char *chars = [string UTF8String];
     NSUInteger length = [string length];
     NSMutableData *data = [NSMutableData dataWithCapacity:length / 2];
     char byteChars[3] = {kTerminator, kTerminator, kTerminator};
     unsigned long wholeByte;
     int i = 0;
     
     while (i < length) {
         byteChars[0] = chars[i++];
         byteChars[1] = chars[i++];
         wholeByte = strtoul(byteChars, NULL, 16);
         [data appendBytes:&wholeByte length:1];
     }

     return data;
 }

 @end

 */
