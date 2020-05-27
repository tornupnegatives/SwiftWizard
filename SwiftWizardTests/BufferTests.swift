//
//  BufferTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class BufferTests: XCTestCase {
    var subject: Buffer!
    
    override func setUpWithError() throws {
        let samples: [Double] = [2.0, 3.0, 4.0]
        subject = Buffer(samples: samples, size: 3, sampleRate: 8000)
    }

    override func tearDownWithError() throws {}

    func testSamplesCopied() throws {
        XCTAssertEqual(subject.samples[0], 2.0)
        XCTAssertEqual(subject.samples[1], 3.0)
        XCTAssertEqual(subject.samples[2], 4.0)
    }
    
    func testSize() throws {
        XCTAssertEqual(subject.size, 3)
    }

    func testEnergy() throws {
        XCTAssertEqual(subject.energy(), 29.0)
    }
    
    func testSampleRate() throws {
        XCTAssertEqual(subject.sampleRate, 8000)
    }
    
    func testCopiable() throws {
        let buffer: Buffer = subject.copy()
        
        XCTAssertEqual(buffer.samples[0], 2.0)
        XCTAssertEqual(buffer.samples[1], 3.0)
        XCTAssertEqual(buffer.samples[2], 4.0)
        XCTAssertEqual(buffer.size, 3)
        XCTAssertEqual(buffer.energy(), 29.0)
        XCTAssertEqual(buffer.sampleRate, 8000)
        
        buffer.samples[0] = 1.0
        XCTAssertEqual(subject.samples[0], 2.0)
        XCTAssertEqual(buffer.samples[0], 1.0)
        
    }
}
