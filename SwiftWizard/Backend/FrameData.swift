import Foundation

/// Holds a KParameter and its value
///
/// The KParameter represents a part of a sample to be applied through a certain coefficient of the LPC filter
/// Unvoiced frames will contain 7 KParameters
final class FrameData {
    var reflector: Reflector
    
    private var parameters: [String: Double]?
    private var translatedParameters: [String: Double]?
    
    private var pitch: Double
    private var repeats: Bool
    private var isStopFrame:   Bool
    private var isForDeocding: Bool
    
    init(reflector: Reflector, pitch: Double, repeats: Bool) {
        self.reflector      = reflector
        self.pitch          = pitch
        self.repeats        = repeats
        self.isStopFrame    = false
        self.isForDeocding  = false
    }
    
    static func stopFrame() -> FrameData {
        let reflector: Reflector = Reflector()
        reflector.rms = CodingTable.rms[kStopFrameIndex]
        
        let frameData: FrameData = FrameData(reflector: reflector, pitch: 0, repeats: false)
        frameData.isStopFrame    = true
        
        return frameData
    }
    
    static func frameForDecoding() -> FrameData {
        let reflector: Reflector = Reflector()
        let frameData: FrameData = FrameData(reflector: reflector, pitch: 0, repeats: false)
        
        frameData.isForDeocding  = true
        
        return frameData
    }
    
    func getParameters() -> [String: Double] {
        if parameters == nil {
            parameters = parametersWithTranslate(translate: false)
        }
        return parameters!
    }
    
    func setParameter(parameter: String, value: Double) {
        parameters = nil
        translatedParameters = nil
        
        if parameter == kParameterGain {
            let index: Int    = Int(value)
            let rms:   Double = CodingTable.rms[index]
            reflector.rms     = rms
            
        } else if parameter == kParameterRepeat {
            repeats = (value != 0)
            
        } else if parameter == kParameterPitch {
            let index: Int    = Int(value)
            let pitch: Double = CodingTable.pitch[index]
            self.pitch        = Double(pitch)
        } else {
            let startSubString: String.Index = parameter.index(parameter.startIndex, offsetBy: 1)
            let bin:   Int    = Int(parameter[startSubString...])!
            let index: Int    = Int(value)
            let k:     Double = try! CodingTable.kBinFor(k: bin)[index] // TODO: Handle exception
            
            reflector.ks[bin] = k
        }
    }
    
    func setParameter(parameter: String, translatedValue: Double) {
        parameters = nil
        translatedParameters = nil
        
        if parameter == kParameterGain {
            reflector.rms = translatedValue
        } else if parameter == kParameterRepeat {
            repeats = (translatedValue != 0)
        } else if parameter == kParameterPitch {
            pitch = translatedValue
        } else {
            let startSubString: String.Index = parameter.index(parameter.startIndex, offsetBy: 1)
            let bin:   Int    = Int(parameter[startSubString...]) ?? 0
            
            reflector.ks[bin] = translatedValue
        }
        
    }
    
    private func getTranslatedParameters() -> [String: Double] {
        if translatedParameters == nil {
            translatedParameters = parametersWithTranslate(translate: true)
        }
        return translatedParameters!
    }
    
    private func parametersWithTranslate(translate: Bool) -> [String: Double] {
        var parameters: [String: Double] = [String: Double]() // Set to hold kParameterKeys entries
        parameters[kParameterGain] = parameterizedValueForRMS(rms: reflector.rms!, translate: translate)
        
        if parameters[kParameterGain]! > 0.0 {
            parameters[kParameterRepeat] = parameterizedValueForRepeat(repeats: repeats)
            parameters[kParameterPitch]  = parameterizedValueForPitch(pitch: pitch, translate: translate)
            
            if parameters[kParameterRepeat] == 0 {
                if var ks: [String: Double] = kParametersFrom(from: 1, to: 4, translate: translate) {
                    parameters.merge(ks){(current, _) in current}
                
                    if parameters[kParameterPitch] != 0 && (isForDeocding || reflector.isVoiced) {
                        ks = kParametersFrom(from: 5, to: 10, translate: translate)!
                        parameters.merge(ks){(current, _) in current}
                    }
                }
            }
        }
        return parameters
    }
    
    private func parameterizedValueForK(k: Double, bin: Int, translate: Bool) -> Double {
        let index: Int = ClosestValueFinder.indexFor(actual: k, table: try! CodingTable.kBinFor(k: bin), size: CodingTable.kSizeFor(k: bin))
        
        if translate {
            return try! CodingTable.kBinFor(k: bin)[index]
        } else {
            return Double(index)
        }
    }
    
    private func parameterizedValueForRMS(rms: Double, translate: Bool) -> Double {
        let index: Int = ClosestValueFinder.indexFor(actual: rms, table: CodingTable.rms, size: CodingTable.rmsSize())
        
        if translate {
            return CodingTable.rms[index]
        } else {
            return Double(index)
        }
    }
    
    private func parameterizedValueForPitch(pitch: Double, translate: Bool) -> Double {
        if isForDeocding {
            if pitch == 0 {
                return 0
            }
            
            if UserSettings.sharedInstance.overridePitch {
                let index: Int = Int(UserSettings.sharedInstance.pitchValue)
                return CodingTable.pitch[index]
            }
        } else if reflector.isUnvoiced || pitch == 0 {
            return 0
        }
        
        let offset: Int = Int(UserSettings.sharedInstance.overridePitch ? 0 : UserSettings.sharedInstance.pitchOffset)
        var index:  Int = ClosestValueFinder.indexFor(actual: pitch, table: CodingTable.pitch, size: CodingTable.pitchSize())
        
        index += offset
        
        if index > 63 {
            index = 63
        }
        
        if index < 0 {
            index = 0
        }
        
        if translate {
            return CodingTable.pitch[index]
        } else {
            return Double(index)
        }
    }
    
    private func parameterizedValueForRepeat(repeats: Bool) -> Double {
        return repeats ? 1 : 0
    }
    
    private func kParametersFrom(from: Int, to: Int, translate: Bool) -> [String: Double]? {
        if isStopFrame {
            return nil
        }
        
        var parameters: [String: Double] = [String: Double]()
        for k in from...to {
            let key: String = parameterKeyForK(k: k)
            parameters[key] = parameterizedValueForK(k: reflector.ks[k], bin: k, translate: translate)
        }
        return parameters
    }
    
    private func parameterKeyForK(k: Int) -> String {
        return "k\(k)"
    }
}
