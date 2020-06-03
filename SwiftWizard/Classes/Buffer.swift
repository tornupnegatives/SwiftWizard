// The Buffer object holds samples for processing

import Foundation

final class Buffer {
    var size:       Int
    var sampleRate: Int
    var samples:    [Double]!
    
    // Included in original but appear unused
    // var start:      UInt
    // var end:        UInt
    
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
    
    // Included in original but appears unused
    /*
    init(samples: [Double], size: UInt, sampleRate: UInt, start: UInt, end: UInt) {
        self.samples    = samples
        self.size       = size
        self.sampleRate = sampleRate
        self.start      = start
        self.end        = end
    } */
    
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
