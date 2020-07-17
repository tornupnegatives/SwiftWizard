// The BitPacker parses FrameData into a hex bitsream
// During packing, it first reads in that binary values of passed KParameters
// These values convereted to hex (with an optional "0x" prefix for the Arudino
// These hex nibbles are reversed, switched, and grouped into a format accetable to the TMS5220

import Foundation

// Used to quickly convert the Double parameters to Int
extension Dictionary where Value == Double, Key == String {
    /// Given [String: Double], creates  [String: Int]
    func doubleValuesToInt() -> [String: Int] {
        let keys: [String] = Array(self.keys)
        
        var intValues: [Int] = []
        for value: Double in self.values {
            intValues.append(Int(value))
        }
        
        var newDictionary: [String: Int] = [:]
        var idx: Int = 0
        
        while idx < keys.count {
            let key: String = keys[idx]
            let value: Int = intValues[idx]
            
            newDictionary[key] = value
            
            idx += 1
        }
        
        return newDictionary
    }
}

final class BitPacker {
    private static let kByteStreamDelimiter: String = ","
    
    static var delimiter: String {
        get {
            return kByteStreamDelimiter
        }
    }
    
    private static var unvoicedKeys: [String] {
        get {
            return [kParameterGain, kParameterRepeat, kParameterPitch, kParameterK1, kParameterK2, kParameterK3, kParameterK4]
        }
    }
    
    private static var repeatKeys: [String] {
        get {
            return [kParameterGain, kParameterRepeat, kParameterPitch]
        }
    }
    
    static func pack(frameData: [FrameData]) -> String {
        var parameterListWithInt: [[String: Int]] = []

        for frame in frameData {
            let dict: [String: Double] = frame.getParameters()
            
            parameterListWithInt.append(dict.doubleValuesToInt())
        }
        
        
        let binary:         [String]            = FrameDataBinaryEncoder.process(parameterList: parameterListWithInt)
        let hex:            [String]            = HexConverter.process(nibbles: binary)
        let reversed:       [String]            = NibbleBitReverser.process(nibbles: hex)
        let switched:       [String]            = NibbleSwitcher.process(nibbles: reversed)
        let output:         [String]            = HexFormatter.process(nibbles: switched)
        
        return output.joined(separator: kByteStreamDelimiter)
        
    }
    
    static func unpack(packedData: String) -> [FrameData] {
        let bytes:          [String]    = packedData.components(separatedBy: kByteStreamDelimiter)
        let switched:       [String]    = NibbleSwitcher.process(nibbles: bytes)
        let reversed:       [String]    = NibbleBitReverser.process(nibbles: switched)
        let binary:         String      = HexByteBinaryEncoder.process(hexNibbles: reversed).joined(separator: "")
        return frameDataFor(binary: binary)
    }
    
    static func frameDataFor(binary: String) -> [FrameData] {
        var frames: [FrameData] = []
        var binaryString: String? = binary
        
        while binaryString != nil {
            let frameKeys: [String] = []
            let frame: FrameData = FrameData.frameForDecoding()
            
            for parameter: String in CodingTable.parameters {
                let index: Int = CodingTable.parameters.firstIndex(of: parameter)! // Exists
                
                let parameterBits: Int = CodingTable.bits[index]
                guard let length: Int = binaryString?.count else {
                    break
                }
                
                let shift: Int = (length < parameterBits) ? (parameterBits - length) : 0
                
                var substringIndex: String.Index = binaryString!.index(binaryString!.startIndex, offsetBy: parameterBits - shift)
                let value: Int = BitHelpers.binaryToValue(binary: String(binaryString!.prefix(upTo: substringIndex)))

                if parameterBits > length {
                    binaryString = nil
                    break
                }
                substringIndex = binaryString!.index(binaryString!.startIndex, offsetBy: parameterBits)
                binaryString = String(binaryString!.suffix(from: substringIndex))
                
                frame.setParameter(parameter: parameter, value: Double(value))
                frames.append(frame)
                
                let parameters: [String: Double] = frame.getParameters()
                if parametersAreSilenceAndComplete(parameters: parameters) || parametersAreStopAndComplete(parameters: parameters) ||
                   parametersAreUnvoicedAndComplete(parameters: parameters, frameKeys: frameKeys) ||
                    parametersAreRepeatedAndComplete(parameters: parameters, frameKeys: frameKeys) || binaryString == nil {
                    break
                }
            }
            frames.append(frame)
        }
        return frames
    }

    private static func getKeyIndexPairs(key: String, source: [String]) -> [String: Int] {
        var keyIndexPairs: [String: Int] = [String: Int]()
        for index in source.indices {
            let element: String = source[index]
            if element == key {
                keyIndexPairs[element] = index
            }
        }
        return keyIndexPairs
    }
    
    private static func parametersAreSilenceAndComplete(parameters: [String: Double]) -> Bool {
        return parameters[kParameterGain] == 0
    }
    
    private static func parametersAreStopAndComplete(parameters: [String: Double]) -> Bool {
        return parameters[kParameterGain] == 15
    }
    
    private static func parametersAreUnvoicedAndComplete(parameters: [String: Double], frameKeys: [String]) -> Bool {
        return parameters[kParameterPitch] == 0 && frameHasExactKeys(keys: self.unvoicedKeys, frameKeys: frameKeys)
    }
    
    private static func frameHasExactKeys(keys: [String], frameKeys: [String]) -> Bool {
        if keys.count != frameKeys.count {
            return false
        }
        
        for key in frameKeys {
            if !keys.contains(key) {
                return false
            }
        }
        
        return true
    }
    
    private static func parametersAreRepeatedAndComplete(parameters: [String: Double], frameKeys: [String]) -> Bool {
        return parameters[kParameterRepeat] == 1 && frameHasExactKeys(keys: self.repeatKeys, frameKeys: frameKeys)
    }
}
