// The Buffer object holds samples for processing

import Foundation

final class Buffer {
    var samples:    [Double]?
    var size:       Int
    var sampleRate: Int

    init(size: Int, sampleRate: Int) {
        self.size       = size
        self.sampleRate = sampleRate
    }
    
    init(samples: [Double], size: Int, sampleRate: Int) {
        self.sampleRate = sampleRate
        self.samples    = samples
        self.size       = size
    }

    func energy() -> Double {
        return Autocorrelator.sumOfSquares(buffer: self)
    }
    
    func copy() -> Buffer {
        if samples != nil {
            return Buffer(samples: self.samples!, size: self.size, sampleRate: self.sampleRate)
        }
        else {
            return Buffer(size: self.size, sampleRate: self.sampleRate)
        }
    }
}
