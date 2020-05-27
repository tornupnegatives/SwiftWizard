//
//  UserSettings.swift
//  SwiftWizard
//
//  Created by Joseph Bellahcen on 5/26/20.
//  Copyright © 2020 Joseph Bellahcen. All rights reserved.
//

import Foundation

struct UserSettings{
    //let sharedInstance:             UserSettings = UserSettings()
    var preEmphasisAlpha:           Double
    var sampleRate:                 Double
    var exportSampleRate:           Double
    var frameRate:                  Double
    var maxPitchInHZ:               Double
    var minPitchInHZ:               Double
    var subMultipleThreshold:       Double
    var unvoicedThreshold:          Double
    var pitchValue:                 Double
    var pitchOffset:                Double
    var rmsLimit:                   Double
    var unvoicedRMSLimit:           Double
    var lowPassCutoff:              Double
    var highPassCutoff:             Double
    var speed:                      Double
    var windowWidth:                Double!
    var unvoicedMultiplier:         Double
    var gain:                       Double
    var startSample:                Double!
    var endSample:                  Double!

    var overridePitch:              Bool!
    var preEmphasis:                Bool!
    var normalizeVoicedRMS:         Bool!
    var normalizeUnvoicedRMS:       Bool!
    var excitationFilterOnly:       Bool!
    var skipLeadingSilence:         Bool!
    var includeHexPrefix:           Bool!
    var includeExplicitStopFrame:   Bool!
    
    init(preEmphasisAlpha: Double?, sampleRate: Double?, frameRate: Double?, exportSampleRate: Double?, maxPitchInHZ: Double?,
         minPitchInHZ: Double?, subMultipleThreshold: Double?, pitchValue: Double?, pitchOffset: Double?, unvoicedThreshold: Double?,
         rmsLimit: Double?, unvoicedRMSLimit: Double?, lowPassCutoff: Double?, highPassCutoff: Double?, speed: Double?,
         unvoicedMultiplier: Double?, gain: Double?, windowWidth: Double?){
        self.preEmphasisAlpha       = preEmphasisAlpha      ?? -0.93750
        self.sampleRate             = sampleRate            ?? 8000
        self.frameRate              = frameRate             ?? 25.0
        self.exportSampleRate       = exportSampleRate      ?? 48000
        self.maxPitchInHZ           = maxPitchInHZ          ?? 500
        self.minPitchInHZ           = minPitchInHZ          ?? 50
        self.subMultipleThreshold   = subMultipleThreshold  ?? 0.9
        self.pitchValue             = pitchValue            ?? 0
        self.pitchOffset            = pitchOffset           ?? 0
        self.unvoicedThreshold      = unvoicedThreshold     ?? 0.3
        self.rmsLimit               = rmsLimit              ?? 14
        self.unvoicedRMSLimit       = unvoicedRMSLimit      ?? 14
        self.lowPassCutoff          = lowPassCutoff         ?? 48000
        self.highPassCutoff         = highPassCutoff        ?? 0
        self.speed                  = speed                 ?? 1.0
        self.unvoicedMultiplier     = unvoicedMultiplier    ?? 0.5
        self.gain                   = gain                  ?? 1.0
        self.windowWidth            = windowWidth           ?? 2
    }
    
    init(){
        self.preEmphasisAlpha       = -0.93750
        self.sampleRate             = 8000
        self.frameRate              = 25.0
        self.exportSampleRate       = 48000
        self.maxPitchInHZ           = 500
        self.minPitchInHZ           = 50
        self.subMultipleThreshold   = 0.9
        self.pitchValue             = 0
        self.pitchOffset            = 0
        self.unvoicedThreshold      = 0.3
        self.rmsLimit               = 14
        self.unvoicedRMSLimit       = 14
        self.lowPassCutoff          = 48000
        self.highPassCutoff         = 0
        self.speed                  = 1.0
        self.unvoicedMultiplier     = 0.5
        self.gain                   = 1.0
        self.windowWidth            = 2
    }
}
