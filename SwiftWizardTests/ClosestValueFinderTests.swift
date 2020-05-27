//
//  ClosestValueFinderTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class ClosestValueFinderTests: XCTestCase {
    var subj:    UInt!

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFindsClosestIndexGivenActualAndList() throws {
        let size:   UInt      = 2
        var floats: [Float] = [1.0, 2.0]
        
        subj = ClosestValueFinder.indexFor(actual: 1.25, table: floats, size: size)
        XCTAssertEqual(subj, 0)
        
        subj = ClosestValueFinder.indexFor(actual: 1.75, table: floats, size: size)
        XCTAssertEqual(subj, 1)
        
        floats[0] = 5.0
        floats[1] = 6.0
        subj = ClosestValueFinder.indexFor(actual: -1.0, table: floats, size: size)
        XCTAssertEqual(subj, 0)
        
        subj = ClosestValueFinder.indexFor(actual: 8.0, table: floats, size: size)
        XCTAssertEqual(subj, 1)
    }
}
