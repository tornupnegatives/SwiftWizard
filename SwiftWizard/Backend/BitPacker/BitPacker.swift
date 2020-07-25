import Foundation

private extension Dictionary where Value == Double, Key == String {
    /// Quickly casts all Double values of Integer type
    func castDoubleToInt() -> [String: Int] {
        let keys: [String] = Array(self.keys)
        
        var intValues: [Int] = []
        for value: Double in self.values {
            intValues.append(Int(value))
        }
        
        var new: [String: Int] = [:]
        var idx: Int = 0
        
        while idx < keys.count {
            let key: String = keys[idx]
            let value: Int = intValues[idx]
            
            new[key] = value
            
            idx += 1
        }
        
        return new
    }
}

/// Parses FrameData into a hex bitsream
///
/// During packing, it first reads in that binary values of passed KParameters
/// These values convereted to hex (with an optional "0x" prefix for the Arudino
/// These hex nibbles are reversed, switched, and grouped into a format accetable to the TMS5220
final class BitPacker {
    private static let kByteStreamDelimiter: String = ","
    
    static var delimiter: String {
        get {
            return kByteStreamDelimiter
        }
    }
    
    static func pack(frameData: [FrameData]) -> String {
        var parameterListWithInt: [[String: Int]] = []

        for frame in frameData {
            let dict: [String: Double] = frame.getParameters()
            
            parameterListWithInt.append(dict.castDoubleToInt())
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
            var frameKeys: [String] = []
            let frame: FrameData = FrameData.frameForDecoding()
            
            for parameter: String in CodingTable.parameters {
                let index: Int = CodingTable.parameters.firstIndex(of: parameter)! // Exists
                let parameterBits: Int = CodingTable.bits[index]
                
                guard let length: Int = binaryString?.count else {
                    break
                }
                
                if parameterBits > length {
                    binaryString = nil
                    break
                }
                
                let shift: Int = (length < parameterBits) ? (parameterBits - length) : 0
                
                var substringIndex: String.Index = binaryString!.index(binaryString!.startIndex, offsetBy: parameterBits - shift)
                let value: Int = BitHelpers.binaryToValue(binary: String(binaryString!.prefix(upTo: substringIndex))) << shift

                substringIndex = binaryString!.index(binaryString!.startIndex, offsetBy: parameterBits)
                binaryString = String(binaryString!.suffix(from: substringIndex))
                
                frame.setParameter(parameter: parameter, value: Double(value))
                frameKeys.append(parameter)
                
                let parameters: [String: Double] = frame.getParameters()
                if parametersAreSilenceAndComplete(parameters: parameters) || parametersAreStopAndComplete(parameters: parameters) ||
                   parametersAreUnvoicedAndComplete(parameters: parameters, frameKeys: frameKeys) ||
                    parametersAreRepeatedAndComplete(parameters: parameters, frameKeys: frameKeys) {
                    break
                }
            }
            frames.append(frame)
        }
        return frames
    }
    
    // MARK: Helper Methods
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

    private static func getKeyIndexes(key: String, source: [String]) -> [String: Int] {
        var keyIndexes: [String: Int] = [String: Int]()
        for index in source.indices {
            let element: String = source[index]
            if element == key {
                keyIndexes[element] = index
            }
        }
        return keyIndexes
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
