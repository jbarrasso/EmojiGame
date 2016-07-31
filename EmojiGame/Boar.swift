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
        
        let moveLeft = SKAction.moveBy(CGVector(dx: -100, dy: 0), duration: 1.0)
        let turnAround = SKAction.runBlock({ self.xScale = (-1 * self.xScale) })
        let delay = SKAction.waitForDuration(0.5)
        let moveRight = SKAction.moveBy(CGVector(dx: 100, dy: 0), duration: 1.0)
        
        let sequence = SKAction.sequence([moveLeft, delay, turnAround, delay, moveRight, delay,turnAround, delay])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    
    func Attack() {
        
        //wait for mainCharacter to come in range
        //stop actions
        //roll in place for 2 seconds, shoot forward
    }
    
    func Dead() {
        
        self.removeAllActions()
    }
    
    func update(currentTime: NSTimeInterval) {
        
    }
}