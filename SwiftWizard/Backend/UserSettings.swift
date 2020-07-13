// The UserSettings singleton provides some global defaults for controlling SwiftWizard

import Foundation

struct UserSettings{
    static var sharedInstance:      UserSettings = UserSettings()
    
    var startSample:                Double!
    var endSample:                  Double!
    
    var preEmphasisAlpha:           Double
    var sampleRate:                 Double
    var frameRate:                  Double
    var exportSampleRate:           Double
    var maxPitchInHZ:               Double
    var minPitchInHZ:               Double
    var subMultipleThreshold:       Double
    var pitchValue:                 Double
    var pitchOffset:                Double
    var unvoicedThreshold:          Double
    var rmsLimit:                   Double
    var unvoicedRMSLimit:           Double
    var lowPassCutoff:              Double
    var highPassCutoff:             Double
    var speed:                      Double
    var unvoicedMultiplier:         Double
    var gain:                       Double
    var windowWidth:                Double
    
    var overridePitch:              Bool    = false
    var preEmphasis:                Bool    = false
    var normalizeVoicedRMS:         Bool    = false
    var normalizeUnvoicedRMS:       Bool    = false
    var excitationFilterOnly:       Bool    = false
    var skipLeadingSilence:         Bool    = false
    var includeHexPrefix:           Bool    = false
    var includeExplicitStopFrame:   Bool    = false

    private init(){
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
