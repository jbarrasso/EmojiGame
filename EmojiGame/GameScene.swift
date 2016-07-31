//
//  GameScene.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/11/16.
//  Copyright (c) 2016 Jeff Barrasso. All rights reserved.
//

import SpriteKit

enum Side {
    case Left, Right, None
}

enum State {
    case Patrol, Attack, Dead, None
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mainCharacter: SKSpriteNode!
    var moveCharacter = CGVector(dx: 0, dy: 0)
    
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    var spawnTimer: CFTimeInterval = 0
    
    /* Will move character only if this is true */
    var stillTouching: Bool = false
    
    var canJump: Bool = true
    
    var sideTouched: Side = .None
    
    var levelNode: SKNode!
    
    /* Camera helpers */
    var cameraTarget: SKNode?
    
    var jumpButton: MSButtonNode!
    var moveLeftButton: MSButtonNode!
    var moveRightButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.8);
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
        jumpButton = self.childNodeWithName("//jumpButton") as! MSButtonNode
        
        moveLeftButton = self.childNodeWithName("//moveLeftButton") as! MSButtonNode
        
        moveRightButton = self.childNodeWithName("//moveRightButton") as! MSButtonNode
        
        
        /* Setup jump button selection handler */
        jumpButton.selectedHandler = {
            
            if self.canJump {
                
                self.mainCharacter.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch */
            let location = touch.locationInNode(self)
            
            /* Allows charcter movement left/right */
            stillTouching = true
            
            if  location.x > mainCharacter.parent?.convertPoint(mainCharacter.position, toNode: self).x {
                
                sideTouched = .Right
                mainCharacter.physicsBody?.applyAngularImpulse(-0.000725)
                
            } else {
                
                sideTouched = .Left
                mainCharacter.physicsBody?.applyAngularImpulse(0.000725)
            }
            
            /* With each touch, set the camera to target mainCharacter */
            cameraTarget = mainCharacter
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        /* Allows mainCharacter to slow down by avoiding moveChar call in update */
        stillTouching = false
        
        if mainCharacter.physicsBody?.velocity.dx > 0 {
            
            /* Dynamic angular & linear forces to slow character down appropriately */
            let stoppingForce = (mainCharacter.physicsBody?.velocity.dx)! / 85
            let reverseRotation = (mainCharacter.physicsBody?.angularVelocity)! / 9000
            
            mainCharacter.physicsBody?.applyAngularImpulse(-reverseRotation)
            mainCharacter.physicsBody?.applyImpulse(CGVectorMake(-stoppingForce, 0))
            
        } else if mainCharacter.physicsBody?.velocity.dx < 0 {
            
            let stoppingForce = (mainCharacter.physicsBody?.velocity.dx)! / 85
            let reverseRotation = (mainCharacter.physicsBody?.angularVelocity)! / 9000
            
            mainCharacter.physicsBody?.applyAngularImpulse(-reverseRotation)
            mainCharacter.physicsBody?.applyImpulse(CGVectorMake(-stoppingForce, 0))
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x+100, y:camera!.position.y)
            
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 300)
        }
        
        let velocityX = mainCharacter.physicsBody?.velocity.dx ?? 0
        
        /* Check and cap velocity */
        if velocityX > 210 {
            
            mainCharacter.physicsBody?.velocity.dx = 210
        } else if velocityX < -210 {
            
            mainCharacter.physicsBody?.velocity.dx = -210
        }
        
        if mainCharacter.physicsBody?.velocity.length() > 85 {
            
            mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
            
        } else {
            
            mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
        }
        
        spawnTimer+=fixedDelta
        
        moveChar()
        
        /* Additional character dampers */
        if mainCharacter.physicsBody?.velocity.dx != 0 && !stillTouching {
            
            mainCharacter.physicsBody?.linearDamping = 1.0
            mainCharacter.physicsBody?.friction = 1.0
        } else {
            mainCharacter.physicsBody?.linearDamping = 0.2
            mainCharacter.physicsBody?.friction = 0.2
        }
        
        if self.mainCharacter.physicsBody?.velocity.dy != 0 {
            //or do sincetouch
            
            self.canJump = false
        } else {
            
            self.canJump = true
        }
    }
    
    func moveChar() {
        /* Touch & hold to move using boolean values */
        
        /* Default set to false */
        if stillTouching {
            
            if sideTouched == .Right {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(8, 0))
            }
                
            else if sideTouched == .Left {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(-8, 0))
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        if contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8 {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = Jungle(fileNamed:"Jungle") as Jungle!
            
            /* Ensure correct aspect mode (iPhone + iPad) */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
}
