//
//  Tiger.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/27/16.
//  Copyright © 2016 Jeff Barrasso. All rights reserved.
//

import Foundation

import SpriteKit

class Tiger: SKSpriteNode {
    
    var state: State = .Patrol
    
    func Patrol() {
        
        //applyForce left 
            //wait 2 seconds
                //applyForce right
    }
    
    func Attack() {
        
        //if mainCharacter comes in range, stop what you're doing and charge
            //stop actions
                //roll in place for 2 seconds, shoot forward
    }
    
    func Dead() {
        
        //stop all actions
            //fade and remove
    }
}