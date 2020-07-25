//
//  HexConverterTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 7/9/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class HexConverterTests: XCTestCase {
    var subject: [String]!
    
    override func setUpWithError() throws {
        super.setUp()
        let binary: [String] = ["1001", "0000", "0010", "1011", "0110", "0110", "0110", "0110", "1000", "0001", "1010", "0000", "1101", "0010",
                                "1010", "0101", "0000", "0101", "0101", "0110", "1011", "1010", "1010", "1101", "0110", "1101", "0111", "1010",
                                "0110", "0101", "1010", "0010", "1110", "1000", "0001", "0101", "0111", "1010", "0011", "0000"]
        subject = HexConverter.process(nibbles: binary)
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testConvertsBinaryNibblesToHex() throws {
        let expected: [String] = ["90", "2b", "66", "66", "81", "a0", "d2", "a5", "05", "56", "ba", "ad", "6d", "7a", "65", "a2", "e8", "15",
                                  "7a", "30"]
        XCTAssertEqual(subject, expected)
    }
}
