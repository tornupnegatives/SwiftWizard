//
//  Buffer.swift
//  SwiftWizard
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import Foundation

final class Buffer {
    var size:       UInt
    var sampleRate: UInt
    
    var samples:    [Double]!
    var start:      UInt?
    var end:        UInt?
    
    // initWithSize()
    init(size: UInt, sampleRate: UInt) {
        self.size       = size
        self.sampleRate = sampleRate
    }
    
    // initWithSamples
    init(samples: [Double], size: UInt, sampleRate: UInt) {
        self.samples    = samples
        self.size       = size
        self.sampleRate = sampleRate
    }
    
    // initWithSamples
    init(samples: [Double], size: UInt, sampleRate: UInt, start: UInt, end: UInt) {
        self.samples    = samples
        self.size       = size
        self.sampleRate = sampleRate
        self.start      = start
        self.end        = end
    }
    
    func energy() -> Double {
        return Autocorrelator.sumOfSquaresFor(buffer: self)
    }
    
    func copy(with zone: NSZone? = nil) -> Buffer {
        if samples != nil {
            return Buffer(samples: self.samples!, size: self.size, sampleRate: self.sampleRate)
        }
        else {
            return Buffer(size: self.size, sampleRate: self.sampleRate)
        }
    }
}
