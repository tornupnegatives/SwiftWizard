//
//  BitHelpers.swift
//  SwiftWizard
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import Foundation

final class BitHelpers {
    static func valueToBinary(value: UInt, bits: UInt) -> String {
        var value = value
        var binary: String = ""
        
        repeat {
            binary = String(format: "%lu", value & 1) + binary
            value >>= 1
        } while value > 0
        
        return leftZeroPadded(binary: binary, bits: bits)
    }
    
    private static func leftZeroPadded(binary: String, bits: UInt) -> String {
        var binary: String = binary
        
        while binary.count < bits {
            binary = "0\(binary)"
        }
        return binary
    }
    
    static func valueForBinary(binary: String) -> UInt {
        var value: UInt = 0
        let cString: String = String(describing: binary.cString(using: String.Encoding.utf8)) // Thanks alessandro-ornano
        let length = cString.count
        
        for offset in length...0 {
            if cString[cString.index(cString.startIndex, offsetBy: offset)] == "1" {
                value += (1 << abs(offset - length))
            }
        }
        return value
    }
    
    static func byteToValue(byte: String) -> UInt {
        return UInt(byte) ?? 0  // TODO: TEST
    }
    
}
