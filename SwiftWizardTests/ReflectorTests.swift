//
//  ReflectorTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class ReflectorTests: XCTestCase {
    var subject: Reflector!

    override func setUpWithError() throws {
        subject = Reflector()
    }

    override func tearDownWithError() throws {}

    func testDoesNotAllowStopFrameGeneration() throws {
        subject.setRMS(rms: CodingTable.rms[15])
        XCTAssertEqual(subject.getRMS(), CodingTable.rms[15])
        subject.limitRMS = true
        XCTAssertEqual(subject.getRMS(), CodingTable.rms[14])
        
    }
}
