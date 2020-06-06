// The Buffer object holds samples for processing

import Foundation

final class Buffer {
    var size:       Int
    var sampleRate: Int
    var samples:    [Double]!

    // Instantiate an empty buffer
    init(size: Int, sampleRate: Int) {
        self.size       = size
        self.sampleRate = sampleRate
    }
    
    // Instantiate buffer and fill it with samples
    init(samples: [Double], size: Int, sampleRate: Int) {
        self.samples    = samples
        self.size       = size
        self.sampleRate = sampleRate
    }

    func energy() -> Double {
        return Autocorrelator.sumOfSquares(buffer: self)
    }
    
    func copy() -> Buffer {
        if samples != nil {
            return Buffer(samples: self.samples, size: self.size, sampleRate: self.sampleRate)
        }
        else {
            return Buffer(size: self.size, sampleRate: self.sampleRate)
        }
    }
}
