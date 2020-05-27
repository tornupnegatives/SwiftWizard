//
//  Reflector.swift
//  SwiftWizard
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import Foundation

final class Reflector {
    private let kNumberofKParameters = 11
    private var ks:       [Double]
    private var rms:      Float!
    var limitRMS:         Bool!
    var isVoiced:         Bool
    var isUnvoiced:       Bool
    
    init(){
        ks = [Double]()
        for _ in 0...kNumberofKParameters {
            ks.append(0)
        }
        
        isUnvoiced      = self.ks[1] >= UserSettings().unvoicedThreshold
        isVoiced        = !isUnvoiced
    }
    
    init(ks: [Double], rms: Float, limitRMS: Bool){
        self.rms        = rms
        self.limitRMS   = limitRMS
        self.ks         = ks
        
        isUnvoiced      = self.ks[1] >= UserSettings().unvoicedThreshold
        isVoiced        = !isUnvoiced
    }
    
    static func translateCoefficients(r: [Double], numberOfSamples: UInt) -> Reflector {
        // Leroux Guegen algorithm for finding Ks
        var k: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var b: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var d: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        k[1] = -r[1] / r[0]
        d[1] =  r[1]
        d[2] =  r[0] + (k[1] * r[1])
        
        for i in 2...10 {
            var y: Double = r[i]
            b[1] = y
            
            for j in 1...(i-1) {
                b[j + 1] = d[j] + (k[j] * y)
                y += (k[j] * d[j])
                d[j] = b[j]
            }
            
            k[i] = -y / d[i];
            d[i + 1] = d[i] + (k[i] * y);
            d[i] = b[i];
        }
        
        let rms: Float = formattedRMS(rms: Float(d[11]), numberOfSamples: numberOfSamples)
        return Reflector(ks: k, rms: rms, limitRMS: true)
    }
    
    private static func formattedRMS(rms: Float, numberOfSamples: UInt) -> Float {
        return sqrt(rms / Float(numberOfSamples)) * Float(1 << 15)
    }
    
    func setRMS(rms: Float) {
        self.rms = rms
    }
    
    func getRMS() -> Float {
        if limitRMS == true && rms >= CodingTable.rms[Int(CodingTable.kStopFrameIndex) - 1] {
            return CodingTable.rms[Int(CodingTable.kStopFrameIndex) - 1]
            
        } else {
            return rms
        }
    }
}
