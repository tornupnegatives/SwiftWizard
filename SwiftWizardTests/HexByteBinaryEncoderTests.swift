//
//  HexByteBinaryEncoder.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 6/16/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class HexByteBinaryEncoderTests: XCTestCase {
    var subject: [String]!
    var hex:     [String]!

    override func setUpWithError() throws {
        hex = ["90","2b","66","66","81","a0","d2","a5","05","56","ba","ad","6d","7a","65","a2","e8","15","7a","30"]
        subject = HexByteBinaryEncoder.process(hexNibbles: hex)
    }

    override func tearDownWithError() throws {}
    
    func testConvertsHexIntoBinaryNibbles() throws {
        let expected: [String] = ["1001","0000","0010","1011","0110","0110","0110","0110","1000","0001",
                                  "1010","0000","1101","0010","1010","0101","0000","0101","0101","0110",
                                  "1011","1010","1010","1101","0110","1101","0111","1010","0110","0101",
                                  "1010","0010","1110","1000","0001","0101","0111","1010","0011","0000"]
        
        XCTAssertEqual(subject, expected)
    }
}
