//
//  NibbleSwitcherTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 6/29/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class NibbleSwitcherTests: XCTestCase {
    var subject: [String]!

    override func setUpWithError() throws {
        let hex: [String] = ["90", "4d", "66", "66", "18", "50", "b4", "5a", "0a", "a6", "d5", "5b", "6b", "e5", "6a", "54", "71", "8a", "e5",
                             "c0"]
        subject = NibbleSwitcher.process(nibbles: hex)
        
    }
    
    func testSwitchesNibbles() throws {
        let expected: [String] = ["09", "d4", "66", "66", "81", "05", "4b", "a5", "a0", "6a", "5d", "b5", "b6", "5e", "a6", "45", "17", "a8",
                                  "5e", "0c" ]
        XCTAssertEqual(subject, expected)
        
    }
}
