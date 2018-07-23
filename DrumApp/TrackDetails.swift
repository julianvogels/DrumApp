//
//  TrackDetails.swift
//  Multy Function Keys
//
//  Created by Daniel Henshaw on 17/7/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

enum PlayDirection {
    case forward, reverse, random, pingPongForward, pingPongReverse
}

struct TrackDetails {
    
    var playDirection : PlayDirection
    var mute : Bool
    var solo : Bool
    var speed : Int
    var loopLength : Int
    
    
    init(playDirection: PlayDirection, mute: Bool, solo: Bool, speed: Int, loopLength : Int) {
        self.playDirection = playDirection
        self.mute = mute
        self.solo = solo
        self.speed = speed
        self.loopLength = loopLength
    }
}
