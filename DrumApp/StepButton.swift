//
//  StepButton.swift
//  Multy Function Keys
//
//  Created by Daniel Henshaw on 28/6/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit


class StepButton: UIButton {
    
    var stepDetails: StepDetails!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(row: Int, column: Int, velocity: Int, pitch: Int, octave: Int, offset: Int, retrigger: Int, probability: Int, roll: Int) {
        self.init(frame: CGRect.zero)
        
        stepDetails = StepDetails(row: row, column: column, velocity: velocity, pitch: pitch, octave: octave, offset: offset, retrigger: retrigger, probability: probability, roll: roll)
        
    }
    
}
