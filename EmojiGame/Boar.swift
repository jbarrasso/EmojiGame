//
//  Boar.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/27/16.
//  Copyright © 2016 Jeff Barrasso. All rights reserved.
//

import Foundation

import SpriteKit

class Boar: SKSpriteNode {
    
    var state: State = .Patrol
    
    func Patrol() {
        
        
    }
    
    func Attack() {
        
        //wait for mainCharacter to come in range
        //stop actions
        //roll in place for 2 seconds, shoot forward
    }
    
    func Dead() {
        
        //stop all actions
        //fade and remove
    }
}