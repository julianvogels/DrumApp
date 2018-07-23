//
//  ViewController.swift
//  Multy Function Keys
//
//  Created by Daniel Henshaw on 28/6/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit
import SnapKit
import Darwin
import AudioKit

class MainViewController: UIViewController, SequencerPositionDelegate {
    
    let conductor = Conductor()
    
    var playButton : UIButton!
    var stopButton : UIButton!
    var homeButton : UIButton!
    var presetButton :UIButton!
    var randomButton : UIButton!
    var shiftButton : UIButton!
    var trackSpeedButton : UIButton!
    var trackLengthButton : UIButton!
    
    let controllerStack = UIStackView()
    let sequencerStack = UIStackView()
    let trackSelectionStack = UIStackView()
    
    var sequencerDetails : SequencerDetails!
    var trackDetailsArray : [TrackDetails]!
    var stepButtonArray : [[StepButton]]!
    var trackButtonArray : [StepButton]!
    
    var trackSelectionLabelArray : [UILabel]!
    
    var currentStep = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var currentStepHasRetriggerd = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var beatCounter = 0
    
    func updateStepCounter(stepPosition: Int) {
        for track in 0 ... 11 {
            if beatCounter % (trackDetailsArray[track].speed + 1 ) == 0 || beatCounter == 0{
                highlightCurrentStep(track: track, currentStep: currentStep[track])
                updateNextStep(track: track)
            }
        }
        beatCounter += 1
    }
    
    let buttonLabels = ["VEL", "PTCH", "OCTV", "OFFST", "RTRG", "%", "RMP ▲", "RMP ▼", "RVRS", "PNG", "RNDM", "LNGTH", "SPD", "SOLO", "MUTE", "FX"]
    var currentTrack = 0
    
    var buttonActiveColour = UIColor(red: 237/255, green: 141/255, blue: 141/255, alpha: 1)
    var buttonBoarderColour = UIColor(red: 77/255, green: 69/255, blue: 69/255, alpha: 1)
    var trackInidicatorColour = UIColor(red: 141/255, green: 98/255, blue: 98/255, alpha: 1)
    var screenBackgroundColour = UIColor(red: 57/255, green: 50/255, blue: 50/255, alpha: 1)
    var soloButtonColour = UIColor.yellow
    var muteButtonColour = UIColor.blue
    var stepSequencePositionColour = UIColor.red
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = screenBackgroundColour
        configureSequencerView()
        configureControlsView()
        configureTrackSelectionView()
        addConstraints()
        conductor.sequencerPositionDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func enterStepParameterValues(track: Int, condition: Int) {
        
        switch condition {
        case 0 :
            sequencerDetails.selectedParameter = .velocity
            changeViewInToSelectedSequencerMode(track: track)
        case 1 :
            sequencerDetails.selectedParameter = .pitch
            changeViewInToSelectedSequencerMode(track: track)
        case 2 :
            sequencerDetails.selectedParameter = .octave
            changeViewInToSelectedSequencerMode(track: track)
        case 3 :
            sequencerDetails.selectedParameter = .offset
            changeViewInToSelectedSequencerMode(track: track)
        case 4 :
            sequencerDetails.selectedParameter = .retrigger
            changeViewInToSelectedSequencerMode(track: track)
        case 5 :
            sequencerDetails.selectedParameter = .probability
            changeViewInToSelectedSequencerMode(track: track)
        case 6 :
            sequencerDetails.selectedParameter = .roll
            changeViewInToSelectedSequencerMode(track: track)
        case 7 :
            sequencerDetails.selectedParameter = .roll
            changeViewInToSelectedSequencerMode(track: track)
        case 8 : configurePlayDirection(track: track, direction: .reverse)
        case 9 : configurePlayDirection(track: track, direction: .pingPongForward)
        case 10 : configurePlayDirection(track: track, direction: .random)
        case 11 : print("need to implement feature")
        case 12 : print("need to implement feature")
        case 13 : soloTrack(track: track)
        case 14 : muteTrack(track: track)
        case 15 : print("need to implement feature")
        default : print("Unrecognised feature")
        }
        
    }
    
    
    func changeViewInToSelectedSequencerMode(track: Int) {
        currentTrack = track
        sequencerDetails.sequencerMode = .updatingStepDetails
        updateCurrentTrackIndicators()
        updateGridWithButtonStatusForSequencerMode()
    }
    
    
    func updateStepDetails(column: Int, row: Int) {
        
        var trackStepDetail = stepButtonArray[currentTrack][column].stepDetails
        
        clearPreviousStepColours(column: column)
        
        switch sequencerDetails.selectedParameter {
        case .velocity :
            
            if stepButtonArray[currentTrack][column].stepDetails.velocity == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.velocity = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .pitch :
            
            if stepButtonArray[currentTrack][column].stepDetails.pitch == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.pitch = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .octave :
            
            if stepButtonArray[currentTrack][column].stepDetails.octave == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.octave = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .offset :
            
            if stepButtonArray[currentTrack][column].stepDetails.offset == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.offset = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .retrigger :
            
            if stepButtonArray[currentTrack][column].stepDetails.retrigger == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.retrigger = 0
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.retrigger = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .probability :
            
            if stepButtonArray[currentTrack][column].stepDetails.probability == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.probability = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        case .roll :
            
            if stepButtonArray[currentTrack][column].stepDetails.roll == row && stepButtonArray[currentTrack][column].stepDetails.isActive {
                stepButtonArray[currentTrack][column].stepDetails.isActive = false
            } else {
                stepButtonArray[currentTrack][column].stepDetails.isActive = true
                stepButtonArray[currentTrack][column].stepDetails.roll = row
                stepButtonArray[row][column].backgroundColor = buttonActiveColour
            }
            
        default : print("Unrecognised condition. No value entered for track \(currentTrack), step \(column)")
        }
    }
    
    
    
    
    func updateNextStep(track: Int) {
        
        currentStepHasRetriggerd[track] += 1
        
        if currentStepHasRetriggerd[track] >= stepButtonArray[track][currentStep[track]].stepDetails.retrigger {
            
            currentStepHasRetriggerd[track] = 0
            
            
            switch trackDetailsArray[track].playDirection {
            case .forward :
                
                if currentStep[track] == trackDetailsArray[track].loopLength || currentStep[track] == 15 {
                    currentStep[track] = 0
                } else {
                    currentStep[track] += 1
                }
                
            case .random :
                
                currentStep[track] = Int(arc4random_uniform(UInt32(trackDetailsArray[track].loopLength)))
                
            case .reverse :
                
                if currentStep[track] == 0 {
                    currentStep[track] = trackDetailsArray[track].loopLength
                } else {
                    currentStep[track] -= 1
                }
                
            case .pingPongForward :
                
                if currentStep[track] == trackDetailsArray[track].loopLength || currentStep[track] == 15 {
                    currentStep[track] -= 1
                    trackDetailsArray[track].playDirection = .pingPongReverse
                } else {
                    currentStep[track] += 1
                }
                
            case .pingPongReverse :
                
                if currentStep[track] == 0 {
                    currentStep[track] += 1
                    trackDetailsArray[track].playDirection = .pingPongForward
                } else {
                    currentStep[track] -= 1
                }
                
            default : currentStep[track] += 0
                
            }
            
        } else {
            currentStep[track] += 0
        }
    }
    
    
    func highlightCurrentStep(track: Int, currentStep: Int) {
        
        if currentStep % 1 == 0 {
            
            DispatchQueue.main.async {
                self.stepButtonArray[track][currentStep].layer.borderColor = self.stepSequencePositionColour.cgColor
                self.stepButtonArray[track][currentStep].layer.borderWidth = 2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stepButtonArray[track][currentStep].layer.borderColor = self.buttonBoarderColour.cgColor
                self.stepButtonArray[track][currentStep].layer.borderWidth = 0.5
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    func enterRandomOnOffValues(track: Int) {
        for step in 0 ... 15 {
            let randomValue = Int(arc4random_uniform(UInt32(3)))
            if randomValue == 1 {
                stepButtonArray[track][step].stepDetails.isActive = true
                stepButtonArray[track][step].backgroundColor = buttonActiveColour
            } else {
                stepButtonArray[track][step].stepDetails.isActive = false
                stepButtonArray[track][step].backgroundColor = .clear
            }
        }
        sequencerDetails.sequencerMode = .home
    }
    
    
    
    
    func randomiseExistingArrayValues(details: SelectedParameter) {
        
        clearAllButtonColoursAndTitles()
        
        for step in 0 ... 15 {
            let randomValue = Int(arc4random_uniform(UInt32(11))) + 1
            
            if stepButtonArray[currentTrack][step].stepDetails.isActive {
                
                switch details {
                case .velocity : stepButtonArray[currentTrack][step].stepDetails.velocity = randomValue
                case .pitch : stepButtonArray[currentTrack][step].stepDetails.pitch = randomValue
                case .octave : stepButtonArray[currentTrack][step].stepDetails.octave = randomValue
                case .offset : stepButtonArray[currentTrack][step].stepDetails.offset = randomValue
                case .retrigger : stepButtonArray[currentTrack][step].stepDetails.retrigger = randomValue
                case .probability : stepButtonArray[currentTrack][step].stepDetails.probability = randomValue
                case .roll : stepButtonArray[currentTrack][step].stepDetails.roll = randomValue
                default : print("Unrecognised parameter selected")
                }
            }
        }
        
        updateGridWithButtonStatusForSequencerMode()
        
    }
    
    
    
    func enterPresetArrayValues(track: Int, presetNumber: Int) {
        
        var randomArray : [Int] = []
        
        switch presetNumber {
        case 0 : randomArray = [0, 8]
        case 1 : randomArray = [4, 12]
        case 2 : randomArray = [0, 4, 8, 12]
        case 3 : randomArray = [3, 7, 11, 15]
        case 4 : randomArray = [2, 6, 10, 14]
        case 5 : randomArray = [3, 6, 9, 12, 14]
        case 6 : randomArray = [0, 2, 4, 6, 8, 10, 12, 14]
        case 7 : randomArray = [0, 1, 3, 4, 5, 7, 8, 9, 11, 12, 13, 15]
        case 8 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 9 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 10 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 11 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 12 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 13 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 14 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        case 15 : randomArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        default : print("Unrecognised value. Unable to autofill track")
        }
        
        let randomArrayCount = randomArray.count
        
        for step in 0 ... 15 {
            stepButtonArray[track][step].stepDetails.isActive = false
            stepButtonArray[track][step].backgroundColor = .clear
        }
        
        for index in 0 ... randomArrayCount - 1 {
            let step = randomArray[index]
            stepButtonArray[track][step].stepDetails.isActive = true
            stepButtonArray[track][step].backgroundColor = buttonActiveColour
        }
        
        sequencerDetails.sequencerMode = .home
        
    }
    
    func soloTrack(track: Int){
        trackDetailsArray[track].solo = !trackDetailsArray[track].solo
        checkTrackSolos()
    }
    
    func muteTrack(track: Int) {
        trackDetailsArray[track].mute = !trackDetailsArray[track].mute
        checkTrackMutes()
    }
    
    
    
    func configurePlayDirection(track: Int, direction: PlayDirection) {
        
        for row in 8 ... 10 {
            stepButtonArray[track][row].backgroundColor = .clear
        }
        
        if trackDetailsArray[track].playDirection == direction {
            trackDetailsArray[track].playDirection = .forward
        } else {
            trackDetailsArray[track].playDirection = direction
        }
        
        checkTrackDirection()
        
    }
    
    
    
    func turnStepOnOff(track: Int, step: Int) {
        
        stepButtonArray[track][step].stepDetails.isActive = !stepButtonArray[track][step].stepDetails.isActive
        
        if stepButtonArray[track][step].stepDetails.isActive {
            stepButtonArray[track][step].backgroundColor = buttonActiveColour
        } else {
            stepButtonArray[track][step].backgroundColor = .clear
        }
    }
    
    
    
    
    
    
    
    
    
    func updateGridWithButtonStatusForSequencerMode() {
        
        clearAllButtonColoursAndTitles()
        
        var conditionValue = 0
        
        for step in 0 ... 15 {
            if stepButtonArray[currentTrack][step].stepDetails.isActive {
                
                
                var trackStepDetail = stepButtonArray[currentTrack][step].stepDetails
                
                switch sequencerDetails.selectedParameter {
                case .velocity : conditionValue = (trackStepDetail?.velocity)!
                case .pitch : conditionValue = (trackStepDetail?.pitch)!
                case .octave : conditionValue = (trackStepDetail?.octave)!
                case .offset : conditionValue = (trackStepDetail?.offset)!
                case .retrigger : conditionValue = (trackStepDetail?.retrigger)!
                case .probability : conditionValue = (trackStepDetail?.probability)!
                case .roll : conditionValue = (trackStepDetail?.roll)!
                default : print("Unrecognised condition.")
                }
                
                stepButtonArray[conditionValue][step].backgroundColor = buttonActiveColour
            }
        }
    }
    
    
    
    func updateGridWithButtonStatusForHome() {
        
        for track in 0 ... 11 {
            for step in 0 ... 15 {
                if stepButtonArray[track][step].stepDetails.isActive {
                    stepButtonArray[track][step].backgroundColor = buttonActiveColour
                } else {
                    stepButtonArray[track][step].backgroundColor = .clear
                }
            }
        }
    }
    
    
    func clearAllButtonColoursAndTitles() {
        for row in 0 ... 11 {
            for column in 0 ... 15 {
                stepButtonArray[row][column].setTitle("", for: .normal)
                stepButtonArray[row][column].backgroundColor = .clear
            }
        }
    }
    
    func clearPreviousStepColours(column: Int) {
        for row in 0 ... 11 {
            stepButtonArray[row][column].backgroundColor = .clear
        }
    }
    
    
    func updateViewForShiftButton() {
        for row in 0...11 {
            for column in 0...15 {
                stepButtonArray[row][column].setTitle(buttonLabels[column], for: .normal)
                stepButtonArray[row][column].backgroundColor = .clear
            }
        }
        checkTrackDirection()
        checkTrackMutes()
        checkTrackSolos()
    }
    
    func updateViewForHomeScreen() {
        for row in 0...11 {
            for column in 0...15 {
                stepButtonArray[row][column].setTitle("", for: .normal)
                
                if stepButtonArray[row][column].stepDetails.isActive {
                    stepButtonArray[row][column].backgroundColor = buttonActiveColour
                } else {
                    stepButtonArray[row][column].backgroundColor = .clear
                }
            }
        }
    }
    
    func updateViewForTrackLengthSpeedScreen() {
        for row in 0...11 {
            for column in 0...15 {
                
                stepButtonArray[row][column].setTitle("\(column + 1)", for: .normal)
                stepButtonArray[row][column].backgroundColor = .clear
                
                let loopLength = trackDetailsArray[row].loopLength
                let trackSpeed = trackDetailsArray[row].speed
                
                if sequencerDetails.sequencerMode == .awaitingTrackLengthSelection {
                    stepButtonArray[row][loopLength].backgroundColor = buttonActiveColour
                } else if sequencerDetails.sequencerMode == .awaitingTrackSpeedDirection {
                    stepButtonArray[row][trackSpeed].backgroundColor = buttonActiveColour
                }
            }
        }
    }
    
    
    func checkTrackDirection() {
        for track in 0 ... 11 {
            if trackDetailsArray[track].playDirection == .pingPongForward || trackDetailsArray[track].playDirection == .pingPongReverse {
                stepButtonArray[track][9].backgroundColor = buttonActiveColour
            } else if trackDetailsArray[track].playDirection == .reverse {
                stepButtonArray[track][8].backgroundColor = buttonActiveColour
            } else if trackDetailsArray[track].playDirection == .random {
                stepButtonArray[track][10].backgroundColor = buttonActiveColour
            }
        }
    }
    
    func checkTrackMutes() {
        for track in 0 ... 11 {
            if trackDetailsArray[track].mute {
                stepButtonArray[track][14].backgroundColor = muteButtonColour
            }
        }
    }
    
    func checkTrackSolos() {
        for track in 0 ... 11 {
            if trackDetailsArray[track].solo && trackDetailsArray[track].mute {
                stepButtonArray[track][13].backgroundColor = soloButtonColour // NEEDS TO FLASH
            } else if trackDetailsArray[track].solo && !trackDetailsArray[track].mute {
                stepButtonArray[track][13].backgroundColor = soloButtonColour
            }
        }
    }
    
    
    
    func updateCurrentTrackIndicators() {
        for index in 0 ... 11 {
            if sequencerDetails.sequencerMode == .home {
                trackSelectionLabelArray[index].backgroundColor = trackInidicatorColour
            } else {
                trackSelectionLabelArray[index].backgroundColor = .clear
            }
        }
        trackSelectionLabelArray[currentTrack].backgroundColor = trackInidicatorColour
    }
    
    
    
}




extension MainViewController {
    
    func addConstraints() {
        
        view.addSubview(controllerStack)
        controllerStack.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(8)
            $0.width.equalToSuperview().multipliedBy(0.18)
        }
        
        view.addSubview(trackSelectionStack)
        trackSelectionStack.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.left.equalTo(controllerStack.snp.right).offset(8)
            $0.width.equalToSuperview().multipliedBy(0.02)
        }
        
        view.addSubview(sequencerStack)
        sequencerStack.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.left.equalTo(trackSelectionStack.snp.right).offset(8)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(8)
        }
        
    }
    
    func configureTrackSelectionView() {
        
        trackSelectionLabelArray = [UILabel]()
        
        for _ in 0 ... 11 {
            
            let trackSelectionLabel = UILabel()
            trackSelectionLabel.backgroundColor = trackInidicatorColour
            trackSelectionLabel.textAlignment = .center
            trackSelectionLabelArray.append(trackSelectionLabel)
            
            trackSelectionStack.translatesAutoresizingMaskIntoConstraints = false
            trackSelectionStack.axis = .vertical
            trackSelectionStack.distribution = .fillEqually
            trackSelectionStack.addArrangedSubview(trackSelectionLabel)
            
        }
    }
    
    
    // MARK : Configure controls
    func configureControlsView() {
        
        playButton = UIButton()
        playButton.setTitle("PLAY", for: .normal)
        playButton.addTarget(self, action: #selector(playOrPauseSequence), for: .touchUpInside)
        
        stopButton = UIButton()
        stopButton.setTitle("STOP", for: .normal)
        stopButton.addTarget(self, action: #selector(stopSequence), for: .touchUpInside)
        
        homeButton = UIButton()
        homeButton.setTitle("HOME", for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        
        presetButton = UIButton()
        presetButton.setTitle("PRESET", for: .normal)
        presetButton.addTarget(self, action: #selector(presetButtonPressed), for: .touchUpInside)
        
        randomButton = UIButton()
        randomButton.setTitle("RANDOM", for: .normal)
        randomButton.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
        
        shiftButton = UIButton()
        shiftButton.setTitle("SHIFT", for: .normal)
        shiftButton.addTarget(self, action: #selector(shiftButtonPressed), for: .touchUpInside)
        
        trackSpeedButton = UIButton()
        trackSpeedButton.setTitle("TRCK SPD", for: .normal)
        trackSpeedButton.addTarget(self, action: #selector(trackSpeedButtonPressed), for: .touchUpInside)
        
        trackLengthButton = UIButton()
        trackLengthButton.setTitle("TRCK LNGTH", for: .normal)
        trackLengthButton.addTarget(self, action: #selector(trackLengthButtonPressed), for: .touchUpInside)
        
        controllerStack.translatesAutoresizingMaskIntoConstraints = false
        controllerStack.axis = .vertical
        controllerStack.distribution = .fillEqually
        
        controllerStack.addArrangedSubview(homeButton)
        controllerStack.addArrangedSubview(trackSpeedButton)
        controllerStack.addArrangedSubview(trackLengthButton)
        controllerStack.addArrangedSubview(presetButton)
        controllerStack.addArrangedSubview(randomButton)
        controllerStack.addArrangedSubview(stopButton)
        controllerStack.addArrangedSubview(playButton)
        controllerStack.addArrangedSubview(shiftButton)
        
        
    }
    
    
    // MARK : Configure sequencer
    func configureSequencerView() {
        
        sequencerDetails = SequencerDetails(sequencerMode: .home, selectedTrack: .noTrackSelected, selectedParameter: .none, bpm: 120)
        trackDetailsArray = [TrackDetails]()
        stepButtonArray = [[StepButton]]()
        
        for row in 0 ... 11 {
            
            let trackStackView = UIStackView()
            trackStackView.translatesAutoresizingMaskIntoConstraints = false
            trackStackView.axis = .horizontal
            trackStackView.distribution = .fillEqually
            trackStackView.spacing = 8
            
            trackButtonArray = [StepButton]()
            stepButtonArray.append(trackButtonArray)
            
            let trackDetails = TrackDetails(playDirection: .forward, mute: false, solo: false, speed: 0, loopLength: 15)
            trackDetailsArray.append(trackDetails)
            
            for column in 0 ... 15 {
                
                let stepButton = StepButton(row: row, column: column, velocity: 2, pitch: 5, octave: 5, offset: 5, retrigger: 0, probability: 0, roll: 0)
                
                stepButton.addTarget(self, action: #selector(stepTouched), for: .touchUpInside)
                stepButton.tag = (row * 100) + column
                stepButton.layer.borderColor = buttonBoarderColour.cgColor
                stepButton.layer.borderWidth = 0.5
                stepButton.layer.cornerRadius = 8
                stepButton.clipsToBounds = true
                stepButton.titleLabel?.font =  UIFont(name: "Helvetica", size: 12)
                
                stepButtonArray[row].append(stepButton)
                trackStackView.addArrangedSubview(stepButton)
                
            }
            
            sequencerStack.translatesAutoresizingMaskIntoConstraints = false
            sequencerStack.axis = .vertical
            sequencerStack.distribution = .fillEqually
            sequencerStack.spacing = 8
            sequencerStack.addArrangedSubview(trackStackView)
            
        }
    }
    
    @objc func trackSpeedButtonPressed() {
        sequencerDetails.sequencerMode = .awaitingTrackSpeedDirection
        sequencerDetails.selectedParameter = .none
        sequencerDetails.selectedTrack = .noTrackSelected
        updateViewForTrackLengthSpeedScreen()
    }
    
    
    @objc func trackLengthButtonPressed() {
        sequencerDetails.sequencerMode = .awaitingTrackLengthSelection
        sequencerDetails.selectedParameter = .none
        sequencerDetails.selectedTrack = .noTrackSelected
        updateViewForTrackLengthSpeedScreen()
    }
    
    @objc func homeButtonPressed() {
        sequencerDetails.sequencerMode = .home
        sequencerDetails.selectedTrack = .noTrackSelected
        sequencerDetails.selectedParameter = .none
        updateViewForHomeScreen()
        updateCurrentTrackIndicators()
    }
    
    @objc func shiftButtonPressed() {
        sequencerDetails.sequencerMode = .shiftButtonEnabled
        sequencerDetails.selectedParameter = .none
        sequencerDetails.selectedTrack = .noTrackSelected
        updateViewForShiftButton()
    }
    
    
    @objc func randomButtonPressed() {
        if sequencerDetails.sequencerMode == .home {
            sequencerDetails.sequencerMode = .awaitingRandomSelection
        } else if sequencerDetails.selectedParameter != .none && sequencerDetails.sequencerMode != .home {
            randomiseExistingArrayValues(details: sequencerDetails.selectedParameter)
        }
    }
    
    
    @objc func presetButtonPressed() {
        sequencerDetails.sequencerMode = .awaitingPresetSelection
    }
    
    
    
    @objc func playOrPauseSequence() {
        
        conductor.isPlaying = !conductor.isPlaying
        
        if conductor.isPlaying {
            playButton.setTitle("PAUSE", for: .normal)
        } else {
            playButton.setTitle("PLAY", for: .normal)
            for track in 0 ... 11 {
                self.stepButtonArray[track][self.currentStep[track]].layer.borderColor = self.stepSequencePositionColour.cgColor
                self.stepButtonArray[track][self.currentStep[track]].layer.borderWidth = 2
            }
        }
    }
    
    
    
    @objc func stopSequence() {
        
        conductor.isPlaying = false
        conductor.stop()
        conductor.sequencer.rewind()
        playButton.setTitle("PLAY", for: .normal)
        
        for track in 0 ... 11 {
            for step in 0 ... 15 {
                stepButtonArray[track][step].layer.borderColor = buttonBoarderColour.cgColor
                stepButtonArray[track][step].layer.borderWidth = 0.5
            }
        }
        currentStep = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    
    
    @objc func stepTouched(_ sender: UIButton) {
        
        if let sender = sender as? StepButton {
            
            let column = sender.stepDetails.column
            let row = sender.stepDetails.row
            
            switch sequencerDetails.sequencerMode {
            case .home :
                turnStepOnOff(track: row, step: column)
            case .awaitingPresetSelection :
                enterPresetArrayValues(track: row, presetNumber: column)
            case .awaitingRandomSelection :
                enterRandomOnOffValues(track: row)
            case .updatingStepDetails :
                updateStepDetails(column: column, row: row)
            case .shiftButtonEnabled :
                enterStepParameterValues(track: row, condition: column)
            case .awaitingTrackLengthSelection :
                trackDetailsArray[row].loopLength = column
                updateViewForTrackLengthSpeedScreen()
            case .awaitingTrackSpeedDirection :
                trackDetailsArray[row].speed = column
                updateViewForTrackLengthSpeedScreen()
            }
        }
    }
    
}
