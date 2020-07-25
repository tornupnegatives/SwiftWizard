//
//  NibbleBitReverserTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 6/29/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class NibbleBitReverserTests: XCTestCase {
    
    var subject: [String]!

    override func setUpWithError() throws {
        let hex: [String] = ["9", "2b", "66", "66", "81", "a0", "d2", "a5", "05", "56", "ba", "ad", "6d", "7a", "65", "a2", "e8", "15", "7a", "3"]
        subject = NibbleBitReverser.process(nibbles: hex)
    }

    func testReversesBitsInEachByte() throws {
        let expected: [String] = ["90", "4d", "66", "66", "18", "50", "b4", "5a", "0a", "a6", "d5", "5b", "6b", "e5", "6a", "54", "71", "8a", "e5",
                                  "c0"]
        XCTAssertEqual(subject, expected)
    }
}
