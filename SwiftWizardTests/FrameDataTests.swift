//
//  FrameDataTests.swift
//  SwiftWizardTests
//
//  Created by Joseph Bellahcen on 6/3/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import XCTest

class FrameDataTests: XCTestCase {
    var subject:   Frame!
    var reflector: Reflector!

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testHasAllParameters() throws {
        let ks: [Double] = [0.0, 0.0]
        reflector = Reflector(ks: ks, rms: 32, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 32, repeats: false)
        let parameterKeys: [String] = Array(subject.getParameters().keys)

        XCTAssertTrue(parameterKeys.contains(kParameterGain))
        XCTAssertTrue(parameterKeys.contains(kParameterRepeat))
        XCTAssertTrue(parameterKeys.contains(kParameterPitch))
        XCTAssertTrue(parameterKeys.contains(kParameterK1))
        XCTAssertTrue(parameterKeys.contains(kParameterK2))
        XCTAssertTrue(parameterKeys.contains(kParameterK3))
        XCTAssertTrue(parameterKeys.contains(kParameterK4))
        XCTAssertTrue(parameterKeys.contains(kParameterK5))
        XCTAssertTrue(parameterKeys.contains(kParameterK6))
        XCTAssertTrue(parameterKeys.contains(kParameterK7))
        XCTAssertTrue(parameterKeys.contains(kParameterK8))
        XCTAssertTrue(parameterKeys.contains(kParameterK9))
        XCTAssertTrue(parameterKeys.contains(kParameterK10))
        
    }
    
    func testHasUnvoicedParameterWhenK1IsLarge() throws {
        let ks: [Double] = [0.1, 5.0]
        reflector = Reflector(ks: ks, rms: 32, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 32, repeats: false)
        let parameterKeys: [String] = Array(subject.getParameters().keys)
        
        XCTAssertTrue(parameterKeys.contains(kParameterGain))
        XCTAssertTrue(parameterKeys.contains(kParameterRepeat))
        XCTAssertTrue(parameterKeys.contains(kParameterPitch))
        XCTAssertTrue(parameterKeys.contains(kParameterK1))
        XCTAssertTrue(parameterKeys.contains(kParameterK2))
        XCTAssertTrue(parameterKeys.contains(kParameterK3))
        XCTAssertTrue(parameterKeys.contains(kParameterK4))
        XCTAssertFalse(parameterKeys.contains(kParameterK5))
        XCTAssertFalse(parameterKeys.contains(kParameterK6))
        XCTAssertFalse(parameterKeys.contains(kParameterK7))
        XCTAssertFalse(parameterKeys.contains(kParameterK8))
        XCTAssertFalse(parameterKeys.contains(kParameterK9))
        XCTAssertFalse(parameterKeys.contains(kParameterK10))
    }
    
    func testHasUnvoicedParameterWhenPitchIsZero() throws {
        let ks: [Double] = [0.1, 0.1]
        reflector = Reflector(ks: ks, rms: 32, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 0, repeats: false)
        let parameterKeys: [String] = Array(subject.getParameters().keys)
        
        XCTAssertTrue(parameterKeys.contains(kParameterGain))
        XCTAssertTrue(parameterKeys.contains(kParameterRepeat))
        XCTAssertTrue(parameterKeys.contains(kParameterPitch))
        XCTAssertTrue(parameterKeys.contains(kParameterK1))
        XCTAssertTrue(parameterKeys.contains(kParameterK2))
        XCTAssertTrue(parameterKeys.contains(kParameterK3))
        XCTAssertTrue(parameterKeys.contains(kParameterK4))
        XCTAssertFalse(parameterKeys.contains(kParameterK5))
        XCTAssertFalse(parameterKeys.contains(kParameterK6))
        XCTAssertFalse(parameterKeys.contains(kParameterK7))
        XCTAssertFalse(parameterKeys.contains(kParameterK8))
        XCTAssertFalse(parameterKeys.contains(kParameterK9))
        XCTAssertFalse(parameterKeys.contains(kParameterK10))
    }
    
    func testHasOnlyGainParametersWhenGainIsZero() throws {
        let ks: [Double] = [0.0, 0.0]
        reflector = Reflector(ks: ks, rms: 0, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 0, repeats: false)
        let parameterKeys: [String] = Array(subject.getParameters().keys)
        
        XCTAssertTrue(parameterKeys.contains(kParameterGain))
        XCTAssertFalse(parameterKeys.contains(kParameterRepeat))
        XCTAssertFalse(parameterKeys.contains(kParameterPitch))
        XCTAssertFalse(parameterKeys.contains(kParameterK1))
        XCTAssertFalse(parameterKeys.contains(kParameterK2))
        XCTAssertFalse(parameterKeys.contains(kParameterK3))
        XCTAssertFalse(parameterKeys.contains(kParameterK4))
        XCTAssertFalse(parameterKeys.contains(kParameterK5))
        XCTAssertFalse(parameterKeys.contains(kParameterK6))
        XCTAssertFalse(parameterKeys.contains(kParameterK7))
        XCTAssertFalse(parameterKeys.contains(kParameterK8))
        XCTAssertFalse(parameterKeys.contains(kParameterK9))
        XCTAssertFalse(parameterKeys.contains(kParameterK10))
    }
    
    func testHasRepeatParameters() throws {
        let ks: [Double] = [0.0, 0.0]
        reflector = Reflector(ks: ks, rms: 32, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 32, repeats: true)
        let parameterKeys: [String] = Array(subject.getParameters().keys)
        
        XCTAssertTrue(parameterKeys.contains(kParameterGain))
        XCTAssertTrue(parameterKeys.contains(kParameterRepeat))
        XCTAssertTrue(parameterKeys.contains(kParameterPitch))
        XCTAssertFalse(parameterKeys.contains(kParameterK1))
        XCTAssertFalse(parameterKeys.contains(kParameterK2))
        XCTAssertFalse(parameterKeys.contains(kParameterK3))
        XCTAssertFalse(parameterKeys.contains(kParameterK4))
        XCTAssertFalse(parameterKeys.contains(kParameterK5))
        XCTAssertFalse(parameterKeys.contains(kParameterK6))
        XCTAssertFalse(parameterKeys.contains(kParameterK7))
        XCTAssertFalse(parameterKeys.contains(kParameterK8))
        XCTAssertFalse(parameterKeys.contains(kParameterK9))
        XCTAssertFalse(parameterKeys.contains(kParameterK10))
    }
    
    func testHasTranslatedParameters() throws {
        let ks: [Double] = [0.0, 0.0]
        reflector = Reflector(ks: ks, rms: 32, limitRMS: false)
        
        subject = Frame(reflector: reflector, pitch: 32, repeats: true)
        
        XCTAssertFalse(subject.getParameters()[kParameterGain] == 52.0)
    }
}
