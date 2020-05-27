// The Autocorrelator (aka Serial Correlator) processes the audio signal using a delayed copy of itself
// Digital audio input can be represented as a discrete-time signal (finite energy), modeled as a square-summable function
// The resulting coefficients describe the relationship between any two consecutive points

import Foundation

final class Autocorrelator {
    // Returns autocorrelated coefficients from a given buffer
    static func getCoefficients(coefficients: [Double], buffer: Buffer) -> [Double] {
        var newCoefficients: [Double] = Array(repeating: 0, count: 11)
        for i in 0...10 {
            newCoefficients[i] = lagSum(lag: UInt(i), buffer: buffer)
        }
        return newCoefficients
    }
    
    static func sumOfSquares(buffer: Buffer) -> Double {
        return lagSum(lag: 0, buffer: buffer)
    }
    
    // Given lag in units time, lagSum returns a "sum of squares" for consecutive lag-separated values
    private static func lagSum(lag: UInt, buffer: Buffer) -> Double {
        let samples: UInt   = buffer.size - lag
        var sum:     Double = 0.0
        
        for i in 0..<samples {
            sum += buffer.samples[Int(i)] * buffer.samples[Int(i + lag)]
        }
        return sum
    }
    
    // Autocorrelates coefficients while also normalizing to given min/max period values
    static func normalizedCoefficients(coefficients: [Double], buffer: Buffer, minPeriod: UInt, maxPeriod: UInt) -> [Double]{
        var newNormalizedCoefficients: [Double] = coefficients
        for lag in 0...maxPeriod {
            if lag < minPeriod {
                newNormalizedCoefficients[Int(lag)] = 0.0
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
