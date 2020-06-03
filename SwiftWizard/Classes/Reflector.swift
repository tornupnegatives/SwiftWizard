// The Reflector performs linear reflections on the RMS value associated with a set of K coefficients

import Foundation

final class Reflector {
    var ks:                     [Double]
    var isVoiced:               Bool
    var isUnvoiced:             Bool
    var unvoicedThreshold:      Double
    var limitRMS:               Bool!
    
    private let nKParameters:   Int         = 11
    private var rms:            Double!
    
    
    init() {
        ks = Array(repeating: 0, count: 11)
        
        self.unvoicedThreshold = UserSettings.sharedInstance.unvoicedThreshold
        self.isUnvoiced        = ks[1] >= unvoicedThreshold
        self.isVoiced          = !isUnvoiced
    }
    
    init(ks: [Double], rms: Double, limitRMS: Bool) {
        self.rms        = rms
        self.limitRMS   = limitRMS
        self.ks         = ks
        
        self.unvoicedThreshold = UserSettings.sharedInstance.unvoicedThreshold
        self.isUnvoiced        = ks[1] >= unvoicedThreshold
        self.isVoiced          = !isUnvoiced
    }
    
    // Applies Leroux Guegen algorithm to find K coefficients
    static func translateCoefficients(r: [Double], nSamples: Int) -> Reflector {
        var k: [Double] = Array(repeating: 0, count: 11)
        var b: [Double] = Array(repeating: 0, count: 11)
        var d: [Double] = Array(repeating: 0, count: 12)
        
        k[1] = -r[1] / r[0];
        d[1] = r[1];
        d[2] = r[0] + (k[1] * r[1]);
        
        for i in 2...10 {
            var y: Double = r[i]
            b[1] = y
            
            for j in 1...(i - 1) {
                b[j + 1] = d[j] + (k[j] * y);
                y = y + (k[j] * d[j]);
                d[j] = b[j];
            }
            
            k[i] = -y / d[i];
            d[i + 1] = d[i] + (k[i] * y);
            d[i] = b[i];
        }
        let rms: Double = formattedRMS(rms: d[11], nSamples: nSamples)
        return Reflector(ks: k, rms: rms, limitRMS: true)
    }
    
    private static func formattedRMS(rms: Double, nSamples: Int) -> Double {
        return sqrt(rms / Double(nSamples)) * Double(1 << 15)
    }
    
    func getRMS() -> Double {
        // Valid RMS values must not exceed 7789.0. This provides a fallback
        if self.limitRMS && self.rms >= CodingTable.rms[kStopFrameIndex - 1] {
            return CodingTable.rms[kStopFrameIndex - 1]
        } else {
            return self.rms
        }
    }
    
    func setRMS(rms: Double) {
        self.rms = rms
    }
}
