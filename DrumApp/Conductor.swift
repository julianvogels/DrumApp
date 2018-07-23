//
//  Conductor.swift
//  DrumApp
//
//  Created by Dan Henshaw on 16/5/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import AudioKit

protocol SequencerPositionDelegate : class {
    func updateStepCounter(stepPosition: Int)
}

class Conductor {
    
    weak var sequencerPositionDelegate : SequencerPositionDelegate?

    var mixer: AKMixer!

    var tracks : [AKMusicTrack]!
    var callbackInsts :  [AKCallbackInstrument]!

    var sequencer = AKSequencer()
    var stepPosition = 0
    var currentTempo = 120.0 {
        didSet {
            sequencer.setTempo(currentTempo)
        }
    }
    
    var isPlaying = false {
        didSet {
            if isPlaying {
                sequencer.play()
                sequencer.enableLooping()
                sequencer.setTempo(currentTempo)
                sequencer.setLength(AKDuration(beats:16))
            } else {
                sequencer.stop()
            }
        }
    }

    
    init() {
        
        setupTracks()
        setupMetronomeAndSequencerPosition()
        
        startAudioKit()
        
    }
    
    func startAudioKit() {
        do {
            try AudioKit.start()
        } catch {
            print("Couldn't start Audiokit")
        }
    }

    
    func setupTracks() {
        
        /// midi tracks = 0 - 12, sequencer position tracks = 13 - 25, audiotracks = 26 - 38, metronome = 0, 13 and 26
        
        tracks = [AKMusicTrack]()
        callbackInsts = [AKCallbackInstrument]()
    
        for _ in 0 ... 2 {
            tracks.append(sequencer.newTrack()!)
        }
        
        // CREATE CALLBACK TRACKS FOR ENTERED NOTES AND ALSO SEQUENCER POSITION
        for i in 0 ... 2 {
            callbackInsts.append(setUpCallBackFunctions(channel: i))
            tracks[i].setMIDIOutput(callbackInsts[i].midiIn)
        }
    }

    func setupMetronomeAndSequencerPosition() {
        
        // ADD INCREMENTING NOTE NUMBERS AT INCREMENTING POSITIONS FOR SEQUENCER POSITION TRACKS (SEQUENCER POSITION TRACKS EQUAL TRACKS 13 TO 25)
        
            for i in 0 ... 15 {
                let noteNumber = MIDINoteNumber(i)
                let position = AKDuration(beats: Double(i))
                let duration = AKDuration(beats: 0.5)
                
                sequencer.tracks[0].add(noteNumber: noteNumber, velocity: 100, position: position, duration: duration)
            }
            
        }
    
    func stop() {
        stepPosition = 0
    }

    // MARK: - Handling NoteOn Msgs
    fileprivate func setUpCallBackFunctions(channel: Int) -> AKCallbackInstrument{
        
        return  AKCallbackInstrument() { [weak self] status, noteNumber, velocity in
            guard let this = self else { return}
            switch status {
            case .noteOn :
                
                this.sequencerPositionDelegate?.updateStepCounter(stepPosition: (self?.stepPosition)!)
                self?.stepPosition += 1
                
            default : "Unknown midi message sent"
                }
            }
        }

 
    
    
    
    
  
}


