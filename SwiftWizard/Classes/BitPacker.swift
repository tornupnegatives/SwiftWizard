//

import Foundation

final class BitPacker {
    private static let kFrameDataParametersMethodName: String = "parameters"
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
    
    static func pack(frameData: [String]) -> String {
        let parameterList:  [String: Int]       = getKeyIndexPairs(key: kFrameDataParametersMethodName, source: frameData)
        let binary:         [String]            = FrameDataBinaryEncoder.process(parameterList: [parameterList])
        let hex:            [String]            = HexConverter.process(nibbles: binary)
        let reversed:       [String]            = NibbleBitReverser.process(nibbles: hex)
        let switched:       [String]            = NibbleBitReverser.process(nibbles: reversed)
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
        var frames:         [FrameData]    = [FrameData]()
        let bits:           [Int]          = CodingTable.bits
        var binaryString:   String?        = binary
        
        while binaryString != nil {
            var frameKeys: [String] = [String]()
            let frame: FrameData = FrameData.frameForDecoding()
            
            for parameter in CodingTable.parameters {
                let index: Int = CodingTable.parameters.firstIndex(of: parameter)!
                
                let parameterBits: Int = bits[index]
                let length: Int = binaryString!.count
                let shift: Int = (length < parameterBits) ? (parameterBits - length) : 0
                let value: Int = BitHelpers.binaryToValue(binary: String(binaryString!.prefix(parameterBits - shift))) << shift
                
                binaryString = (length >= parameterBits) ? String(binaryString!.suffix(parameterBits)) : nil
                
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
