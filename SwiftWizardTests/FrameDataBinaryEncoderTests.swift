//
//  FrameDataBinaryEncoderTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 5/28/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest
@testable import SwiftWizard

class FrameDataBinaryEncoderTests: XCTestCase {
    var frameData: [[String: Int]]!
    var subject:   [String]!

    override func setUpWithError() throws {
        frameData = [[String: Int]]()
        
        frameData.append(contentsOf: [[kParameterGain: 9],  [kParameterRepeat: 0],
                                      [kParameterPitch: 0], [kParameterK1: 21],
                                      [kParameterK2: 22],   [kParameterK3: 6],
                                      [kParameterK4: 6]])
        
        frameData.append(contentsOf: [[kParameterGain: 6],  [kParameterRepeat: 1],
                                      [kParameterPitch: 0]])
        
        frameData.append(contentsOf: [[kParameterGain: 6],  [kParameterRepeat: 1],
                                      [kParameterPitch: 0]])
        
        frameData.append(contentsOf: [[kParameterGain: 13],  [kParameterRepeat: 0],
                                      [kParameterPitch: 10], [kParameterK1: 18],
                                      [kParameterK2: 16],    [kParameterK3: 5],
                                      [kParameterK4: 5],     [kParameterK5: 6],
                                      [kParameterK6: 11],    [kParameterK7: 10],
                                      [kParameterK8: 5],     [kParameterK9: 3],
                                      [kParameterK10: 2]])
        
        frameData.append(contentsOf: [[kParameterGain: 13],  [kParameterRepeat: 1],
                                      [kParameterPitch: 11]])
        
        frameData.append(contentsOf: [[kParameterGain: 13],  [kParameterRepeat: 0],
                                      [kParameterPitch: 12], [kParameterK1: 22],
                                      [kParameterK2: 17],    [kParameterK3: 7],
                                      [kParameterK4: 4],     [kParameterK5: 0],
                                      [kParameterK6: 10],    [kParameterK7: 11],
                                      [kParameterK8: 6],     [kParameterK9: 4],
                                      [kParameterK10: 3]])
        
        frameData.append(contentsOf: [[kParameterGain: 0]])
        
        CodingTable.bits[2] = 5
        
        subject = FrameDataBinaryEncoder.process(parameterList: frameData)
    }
    
    override func tearDownWithError() throws {
        CodingTable.bits[2] = 6
    }
    
    func testConvertsFramesIntoBinaryNibbles() throws {
        let expected: [String] = [ "1001", "0000", "0010", "1011", "0110", "0110", "0110", "0110", "1000", "0001", "1010", "0000",
                                   "1101", "0010", "1010", "0101", "0000", "0101", "0101", "0110", "1011", "1010", "1010", "1101",
                                   "0110", "1101", "0111", "1010", "0110", "0101", "1010", "0010", "1110", "1000", "0001", "0101",
                                   "0111", "1010", "0011", "0000" ];
        
        XCTAssertEqual(subject, expected);
        
    }
}
