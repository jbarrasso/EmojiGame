//
//  Boar.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/27/16.
//  Copyright © 2016 Jeff Barrasso. All rights reserved.
//

import Foundation

import SpriteKit

class Snake: SKSpriteNode {
    
    var state: State = .Jump
    
    func Jump() {
        
        let jumpUp = SKAction.moveBy(CGVector(dx: 0, dy: 150), duration: 1.0)
        let delay = SKAction.waitForDuration(0.5)
        
        let sequence = SKAction.sequence([jumpUp, delay])
        
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