// The Autocorrelator (aka Serial Correlator) provides static methods for LPC signal processing
// It will generate linear coefficients to describe a discrete-time signal

import Foundation

final class Autocorrelator {
    // Returns autocorrelated coefficients from a given buffer
    static func getCoefficients(coefficients: [Double], buffer: Buffer) -> [Double] {
        var newCoefficients: [Double] = Array(repeating: 0, count: 11)
        for i in 0...10 {
            newCoefficients[i] = lagSum(lag: i, buffer: buffer)
        }
        return newCoefficients
    }
    
    static func sumOfSquares(buffer: Buffer) -> Double {
        return lagSum(lag: 0, buffer: buffer)
    }
    
    // Autocorrelates coefficients while also normalizing to given min/max period values
    static func normalizedCoefficients(coefficients: [Double], buffer: Buffer, minPeriod: Int, maxPeriod: Int) -> [Double]{
        var newNormalizedCoefficients: [Double] = coefficients
        for lag in 0...maxPeriod {
            if lag < minPeriod {
                newNormalizedCoefficients[Int(lag)] = 0.0
            }
            
            var sumOfSquaresBegin:  Double  = 0.0
            var sumOfSquaresEnd:    Double  = 0.0
            
            var sum:                Double  = 0.0
            let samples:            Int     = buffer.size - lag
            
            for i in 0..<samples {
                sum += buffer.samples[Int(i)] * buffer.samples[i + lag]
                sumOfSquaresBegin   += pow(buffer.samples[i], 2)
                sumOfSquaresEnd     += pow(buffer.samples[i + lag], 2)
            }
            newNormalizedCoefficients[lag] = sum / sqrt(sumOfSquaresBegin * sumOfSquaresEnd)
        }
        return newNormalizedCoefficients
    }
    
    // Given lag in units time, lagSum returns a "sum of squares" for consecutive lag-separated values
    private static func lagSum(lag: Int, buffer: Buffer) -> Double {
        let samples: Int   = buffer.size - lag
        var sum:     Double = 0.0
        
        for i in 0..<samples {
            sum += buffer.samples[Int(i)] * buffer.samples[i + lag]
        }
        return sum
    }
}
