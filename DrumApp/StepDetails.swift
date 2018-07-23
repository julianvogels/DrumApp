//
//  StepDetails.swift
//  Multy Function Keys
//
//  Created by Daniel Henshaw on 28/6/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

struct StepDetails {
    
    var isActive : Bool
    var column : Int
    var row : Int
    var velocity : Int
    var pitch : Int
    var octave : Int
    var offset : Int
    var retrigger : Int
    var probability : Int
    var roll : Int
    
    
    init(row: Int, column: Int, velocity: Int, pitch: Int, octave : Int, offset: Int, retrigger: Int, probability: Int, roll: Int) {
        isActive = false
        self.column = column
        self.row = row
        self.velocity = velocity
        self.pitch = pitch
        self.octave = octave
        self.offset = offset
        self.retrigger = retrigger
        self.probability = probability
        self.roll = roll
    }
    
}
