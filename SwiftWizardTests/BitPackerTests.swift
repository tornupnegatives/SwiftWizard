//
//  BitPackerTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 7/2/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class BitPackerTests: XCTestCase {
    
    var frames:                 [FrameData]!
    var byteStream:             String!
    var byteStreamWithPrefix:   String!
    var reflectors:             [Reflector]!
    var bits:                   [Int]!
    
    func frameDataFor(reflector: Reflector, gain: Double, repeats: Bool?, pitch: Double?, k1: Double?, k2: Double?, k3: Double?, k4: Double?,
                      k5: Double?, k6: Double?, k7: Double?, k8: Double?, k9: Double?, k10: Double?) -> FrameData {
        
        let frameData: FrameData = FrameData(reflector: reflector, pitch: 0, repeats: false)
        
        frameData.setParameter(parameter: kParameterGain, value: gain)
        
        if (pitch != nil) {
            frameData.setParameter(parameter: kParameterPitch, value: pitch!)
        }
        
        if (repeats != nil) {
            frameData.setParameter(parameter: kParameterRepeat, value: repeats! ? 1: 0)
        }
        
        if (k1 != nil) {
            frameData.setParameter(parameter: kParameterK1, value: k1!)
        }
        if (k2 != nil) {
            frameData.setParameter(parameter: kParameterK2, value: k2!)
        }
        if (k3 != nil) {
            frameData.setParameter(parameter: kParameterK3, value: k3!)
        }
        if (k4 != nil) {
            frameData.setParameter(parameter: kParameterK4, value: k4!)
        }
        if (k5 != nil) {
            frameData.setParameter(parameter: kParameterK5, value: k5!)
        }
        if (k6 != nil) {
            frameData.setParameter(parameter: kParameterK6, value: k6!)
        }
        if (k7 != nil) {
            frameData.setParameter(parameter: kParameterK7, value: k7!)
        }
        if (k8 != nil) {
            frameData.setParameter(parameter: kParameterK8, value: k8!)
        }
        if (k9 != nil) {
            frameData.setParameter(parameter: kParameterK9, value: k9!)
        }
        if (k10 != nil) {
            frameData.setParameter(parameter: kParameterK10, value: k10!)
        }
        
        return frameData
    }
    
    override func setUpWithError() throws {
        super.setUp()
        
        reflectors = []
        for _ in 0..<10 {
            reflectors.append(Reflector())
        }
        
        frames = [
            self.frameDataFor(reflector: reflectors[0], gain: 9, repeats: false, pitch: 0, k1: 21, k2: 22, k3: 6, k4: 6, k5: nil, k6: nil, k7: nil, k8: nil, k9: nil, k10: nil),
            
            self.frameDataFor(reflector: reflectors[1], gain: 6, repeats: true, pitch: 0, k1: nil, k2: nil, k3: nil, k4: nil, k5: nil, k6: nil, k7: nil, k8: nil, k9: nil, k10: nil),
            
            self.frameDataFor(reflector: reflectors[2], gain: 6, repeats: true, pitch: 0, k1: nil, k2: nil, k3: nil, k4: nil, k5: nil, k6: nil, k7: nil, k8: nil, k9: nil, k10: nil),
            
            self.frameDataFor(reflector: reflectors[3], gain: 13, repeats: false, pitch: 10, k1: 18, k2: 16, k3: 5, k4: 5, k5: 6, k6: 11, k7: 10, k8: 5, k9: 3, k10: 2),
            
            self.frameDataFor(reflector: reflectors[4], gain: 13, repeats: true, pitch: 11, k1: nil, k2: nil, k3: nil, k4: nil, k5: nil, k6: nil, k7: nil, k8: nil, k9: nil, k10: nil),
            
            self.frameDataFor(reflector: reflectors[5], gain: 13, repeats: false, pitch: 12, k1: 22, k2: 17, k3: 7, k4: 4, k5: 0, k6: 10, k7: 11, k8: 6, k9: 4, k10: 3),
            
            self.frameDataFor(reflector: reflectors[6], gain: 0, repeats: nil, pitch: nil, k1: nil, k2: nil, k3: nil, k4: nil, k5: nil, k6: nil, k7: nil, k8: nil, k9: nil, k10: nil)
        ]
        
        byteStream = "09,d4,66,66,81,05,4b,a5,a0,6a,5d,b5,b6,5e,a6,45,17,a8,5e,0c"
        byteStreamWithPrefix = "0x09,0xd4,0x66,0x66,0x81,0x05,0x4b,0xa5,0xa0,0x6a,0x5d,0xb5,0xb6,0x5e,0xa6,0x45,0x17,0xa8,0x5e,0x0c"
        
        CodingTable.bits[2] = 5
    }
    
    override func tearDownWithError() throws {
        CodingTable.bits[2] = 6
        UserSettings.sharedInstance.includeHexPrefix = false
        super.tearDown()
    }
    
    func testPacksFrameIntoByteStream() throws {
        XCTAssertEqual(BitPacker.pack(frameData: frames), byteStream)
        UserSettings.sharedInstance.includeHexPrefix = true
        XCTAssertEqual(BitPacker.pack(frameData: frames), byteStreamWithPrefix)
    }
    
    func testUpacksByteStreamIntoFrame() throws {
        let frameData: [FrameData] = BitPacker.unpack(packedData: byteStream)
        var parameters: [String: Double]
        
        parameters = frameData[0].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 9)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertEqual(parameters[kParameterK1], 21)
        XCTAssertEqual(parameters[kParameterK2], 22)
        XCTAssertEqual(parameters[kParameterK3], 6)
        XCTAssertEqual(parameters[kParameterK4], 6)
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[1].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 6)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[2].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 6)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[3].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 10)
        XCTAssertEqual(parameters[kParameterK1], 18)
        XCTAssertEqual(parameters[kParameterK2], 16)
        XCTAssertEqual(parameters[kParameterK3], 5)
        XCTAssertEqual(parameters[kParameterK4], 5)
        XCTAssertEqual(parameters[kParameterK5], 6)
        XCTAssertEqual(parameters[kParameterK6], 11)
        XCTAssertEqual(parameters[kParameterK7], 10)
        XCTAssertEqual(parameters[kParameterK8], 5)
        XCTAssertEqual(parameters[kParameterK9], 3)
        XCTAssertEqual(parameters[kParameterK10], 2)
        
        parameters = frameData[4].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 11)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[5].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 12)
        XCTAssertEqual(parameters[kParameterK1], 22)
        XCTAssertEqual(parameters[kParameterK2], 17)
        XCTAssertEqual(parameters[kParameterK3], 7)
        XCTAssertEqual(parameters[kParameterK4], 4)
        XCTAssertEqual(parameters[kParameterK5], 0)
        XCTAssertEqual(parameters[kParameterK6], 10)
        XCTAssertEqual(parameters[kParameterK7], 11)
        XCTAssertEqual(parameters[kParameterK8], 6)
        XCTAssertEqual(parameters[kParameterK9], 4)
        XCTAssertEqual(parameters[kParameterK10], 3)
        
        parameters = frameData[6].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 0)
        XCTAssertNil(parameters[kParameterRepeat])
        XCTAssertNil(parameters[kParameterPitch])
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        

    }
    
    func testUnpacksByteStreamWithHexPrefixes() throws {
        let frameData: [Frame] = BitPacker.unpack(packedData: byteStreamWithPrefix)
        var parameters: [String: Double]
        
        parameters = frameData[0].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 9)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertEqual(parameters[kParameterK1], 21)
        XCTAssertEqual(parameters[kParameterK2], 22)
        XCTAssertEqual(parameters[kParameterK3], 6)
        XCTAssertEqual(parameters[kParameterK4], 6)
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[1].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 6)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[2].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 6)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 0)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[3].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 10)
        XCTAssertEqual(parameters[kParameterK1], 18)
        XCTAssertEqual(parameters[kParameterK2], 16)
        XCTAssertEqual(parameters[kParameterK3], 5)
        XCTAssertEqual(parameters[kParameterK4], 5)
        XCTAssertEqual(parameters[kParameterK5], 6)
        XCTAssertEqual(parameters[kParameterK6], 11)
        XCTAssertEqual(parameters[kParameterK7], 10)
        XCTAssertEqual(parameters[kParameterK8], 5)
        XCTAssertEqual(parameters[kParameterK9], 3)
        XCTAssertEqual(parameters[kParameterK10], 2)
        
        parameters = frameData[4].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 1)
        XCTAssertEqual(parameters[kParameterPitch], 11)
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
        parameters = frameData[5].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 13)
        XCTAssertEqual(parameters[kParameterRepeat], 0)
        XCTAssertEqual(parameters[kParameterPitch], 12)
        XCTAssertEqual(parameters[kParameterK1], 22)
        XCTAssertEqual(parameters[kParameterK2], 17)
        XCTAssertEqual(parameters[kParameterK3], 7)
        XCTAssertEqual(parameters[kParameterK4], 4)
        XCTAssertEqual(parameters[kParameterK5], 0)
        XCTAssertEqual(parameters[kParameterK6], 10)
        XCTAssertEqual(parameters[kParameterK7], 11)
        XCTAssertEqual(parameters[kParameterK8], 6)
        XCTAssertEqual(parameters[kParameterK9], 4)
        XCTAssertEqual(parameters[kParameterK10], 3)
        
        parameters = frameData[6].getParameters()
        XCTAssertEqual(parameters[kParameterGain], 0)
        XCTAssertNil(parameters[kParameterRepeat])
        XCTAssertNil(parameters[kParameterPitch])
        XCTAssertNil(parameters[kParameterK1])
        XCTAssertNil(parameters[kParameterK2])
        XCTAssertNil(parameters[kParameterK3])
        XCTAssertNil(parameters[kParameterK4])
        XCTAssertNil(parameters[kParameterK5])
        XCTAssertNil(parameters[kParameterK6])
        XCTAssertNil(parameters[kParameterK7])
        XCTAssertNil(parameters[kParameterK8])
        XCTAssertNil(parameters[kParameterK9])
        XCTAssertNil(parameters[kParameterK10])
        
    }
    
}
