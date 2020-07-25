// The FrameData class takes kParameters and their values and prepares them for processing

import Foundation

final class FrameData {
    var shouldSkip:                           Bool = false
    var reflector:                            Reflector
    
    private var pitch:                        Double
    private var repeats:                      Bool
    private var isDecodeFrame:                Bool = true
    private var isStopFrame:                  Bool = false
    private var parameters:                   [String: Double]?
    private var translatedParameters:         [String: Double]?
    
    
    
    static func stopFrame() -> FrameData {
        let reflector: Reflector = Reflector()
        reflector.setRMS(rms: Double(CodingTable.rms[kStopFrameIndex]))
        
        let frameData: FrameData = FrameData(reflector: reflector, pitch: 0, repeats: false)
        frameData.isStopFrame = true
        
        return frameData
    }
    
    static func frameForDecoding() -> FrameData {
        let reflector: Reflector = Reflector()
        let frameData: FrameData = FrameData(reflector: reflector, pitch: 0, repeats: false)
        frameData.isDecodeFrame = true
        
        return frameData
    }
    
    init(reflector: Reflector, pitch: Double, repeats: Bool) {
        self.reflector = reflector
        self.pitch     = pitch
        self.repeats   = repeats
    }
    
    func getParameters() -> [String: Double] {
        if parameters != nil {
            return parameters!
        } else {
            return parametersWithTranslate(translate: false)
        }
    }
    
    private func getTranslatedParameters() -> [String: Double]? {
        if translatedParameters != nil {
            return translatedParameters
        } else {
            return parametersWithTranslate(translate: false)
        }
    }
    
    private func parametersWithTranslate(translate: Bool) -> [String: Double] {
        var parameters: [String: Double] = [String: Double]()
        
        parameters[kParameterGain] = parameterizedValueForRMS(rms: reflector.rms!, translate: translate)
        if Double(parameters[kParameterGain]!) > 0.0 {
            parameters[kParameterRepeat] = parameterizedValueForRepeat(repeats: repeats)
            parameters[kParameterPitch]  = parameterizedValueForPitch(pitch: pitch, translate: translate)
            
            if parameters[kParameterRepeat] == 0 {
                if let ks: [String: Double] = kParametersFrom(from: 1, to: 4, translate: translate) {
                    parameters.merge(ks, uniquingKeysWith: { $1})
                }
                    
                if parameters[kParameterPitch] != 0 && (isDecodeFrame || reflector.isVoiced) {
                    if let ks =  kParametersFrom(from: 5, to: 10, translate: translate) {
                        parameters.merge(ks, uniquingKeysWith: { $1})
                    }
                }
            }
        }
        return parameters
    }
    
    func setParameter(parameter: String, value: Int) throws {
        parameters = nil
        translatedParameters = nil
        
        if parameter == kParameterGain {
            reflector.setRMS(rms: Double(CodingTable.rms[value]))
        } else if parameter == kParameterRepeat {
            repeats = Bool(value != 0)
        } else if parameter == kParameterPitch {
            pitch = CodingTable.pitch[value]
        } else {
            let binIndex: String.Index = parameter.index(parameter.startIndex, offsetBy: 1) // TODO: Fix this mess
            let binInt:   Int          = Int(parameter[binIndex...parameter.endIndex]) ?? 0
            let bin:      String       = String(parameter[binIndex...])
            let k:        Double       = try CodingTable.kBinFor(k: Int(bin[value].asciiValue ?? 0))[value]
            reflector.ks[binInt]       = k
        }
    }
    
    func setParameter(parameter: String, translatedValue: Int) throws {
        parameters = nil
        translatedParameters = nil
        
        if parameter == kParameterGain {
            reflector.setRMS(rms: Double(CodingTable.rms[translatedValue]))
        } else if parameter == kParameterRepeat {
            repeats = Bool(translatedValue != 0)
        } else if parameter == kParameterPitch {
            pitch = CodingTable.pitch[translatedValue]
        } else {
            let binIndex: String.Index = parameter.index(parameter.startIndex, offsetBy: 1) // TODO: Fix this mess
            let binInt:   Int          = Int(parameter[binIndex...parameter.endIndex]) ?? 0
            let bin:      String       = String(parameter[binIndex...])
            let k:        Double       = try CodingTable.kBinFor(k: Int(bin[translatedValue].asciiValue ?? 0))[translatedValue]
            reflector.ks[binInt]     = k
        }
    }
    
    private func parameterizedValueForK(k: Double, bin: Int, translate: Bool) -> Double {
        let index: Int = ClosestValueFinder.indexFor(actual: k,
                                                     table: try! CodingTable.kBinFor(k: bin),
                                                     size:       CodingTable.kSizeFor(k: bin))
        
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
        if isDecodeFrame == true {
            if pitch == 0.0 {return 0}
            
            if UserSettings.sharedInstance.overridePitch {
                let index: Int = Int(UserSettings.sharedInstance.pitchValue)
                return CodingTable.pitch[index]
            }
        } else if reflector.isUnvoiced || pitch == 0.0 {
            return 0
        }
        
        let offset: Int = UserSettings.sharedInstance.overridePitch ? 0 : Int(UserSettings.sharedInstance.pitchOffset)
        var index: Int = ClosestValueFinder.indexFor(actual: pitch, table: CodingTable.pitch, size: CodingTable.pitchSize()) + offset
        
        if index > 63 {index = 63}
        if index < 0  {index = 0}
        
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
        
        var index: Int = from
        while index <= to {
            let key:       String = parameterKeyForK(index: index)
            let parameter: Double = parameterizedValueForK(k: reflector.ks[index], bin: index, translate: translate)
            parameters[key]       = parameter

            index += 1
        }
        return parameters
    }
    
    private func parameterKeyForK(index: Int) -> String {
        return "k\(index)"
    }
}
