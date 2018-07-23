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

enum Speed {
    case quadruple, triple, double, normal, half, third, quarter, eighth
}

struct TrackDetails {
    
    var playDirection : PlayDirection
    var mute : Bool
    var solo : Bool
    var speed : Speed
    var loopLength : Int
    

    init(playDirection: PlayDirection, mute: Bool, solo: Bool, speed: Speed, loopLength : Int) {
        self.playDirection = playDirection
        self.mute = mute
        self.solo = solo
        self.speed = speed
        self.loopLength = loopLength
    }
}
