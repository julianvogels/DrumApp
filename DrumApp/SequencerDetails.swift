//
//  SequencerDetails.swift
//  Multy Function Keys
//
//  Created by Daniel Henshaw on 17/7/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

enum SequencerMode {
    case home, shiftButtonEnabled, awaitingRandomSelection, awaitingPresetSelection, updatingStepDetails, awaitingTrackSpeedDirection, awaitingTrackLengthSelection
}

enum SelectedParameter {
    case none, velocity, pitch, octave, offset, retrigger, probability, roll
}

enum SelectedTrack {
    case noTrackSelected, track00, track01, track02, track03, track04, track05, track06, track07, track08, track09, track10, track11
}


struct SequencerDetails {
    
    var sequencerMode : SequencerMode
    var selectedTrack : SelectedTrack
    var selectedParameter : SelectedParameter
    var bpm : Int
    
    init(sequencerMode : SequencerMode, selectedTrack : SelectedTrack, selectedParameter : SelectedParameter, bpm : Int) {
        self.sequencerMode = sequencerMode
        self.selectedTrack = selectedTrack
        self.selectedParameter = selectedParameter
        self.bpm = bpm
    }
    
}
