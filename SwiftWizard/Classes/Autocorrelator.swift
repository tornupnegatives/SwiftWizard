//
//  Autocorrelator.swift
//  SwiftWizard
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import Foundation

final class Autocorrelator {
    static func getCoefficientsFor(coefficients: [Double], buffer: Buffer) -> [Double] {
        var newCoefficients: [Double] = [Double]()
        for i in 0...10 {
            newCoefficients.append(aForLag(lag: UInt(i), buffer: buffer))
        }
        return newCoefficients
    }
    
    static func sumOfSquaresFor(buffer: Buffer) -> Double {
        return aForLag(lag: 0, buffer: buffer)
    }
    
    private static func aForLag(lag: UInt, buffer: Buffer) -> Double {
        let samples: UInt   = buffer.size - lag
        var sum:     Double = 0.0
        
        for i in 0..<samples {
            sum += buffer.samples[Int(i)] * buffer.samples[Int(i + lag)]
        }
        return sum
    }
    
    static func getNormalizedCoefficientsFor(coefficients: [Double], buffer: Buffer, minPeriod: UInt, maxPeriod: UInt) -> [Double]{
        var newNormalizedCoefficients: [Double] = [Double]()
        for lag in 0...maxPeriod {
            if lag < minPeriod {
                newNormalizedCoefficients.append(0.0)
                continue
            }
            
            var sumOfSquaresBegin:  Double  = 0.0
            var sumOfSquaresEnd:    Double  = 0.0
            var sum:                Double  = 0.0
            let samples:            UInt    = buffer.size - lag
            
            for i in 0..<samples {
                sum += buffer.samples[Int(i)] * buffer.samples[Int(i + lag)]
                sumOfSquaresBegin   += pow(buffer.samples[Int(i)], 2)
                sumOfSquaresEnd     += pow(buffer.samples[Int(i + lag)], 2)
            }
            newNormalizedCoefficients[Int(lag)] = sum / sqrt(sumOfSquaresBegin * sumOfSquaresEnd)
        }
        return newNormalizedCoefficients
    }
}

