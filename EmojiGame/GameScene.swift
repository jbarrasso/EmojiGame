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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mainCharacter: SKSpriteNode!
    var moveCharacter = CGVector(dx: 0, dy: 0)
    
    var sideTouched: Side = .None
    
    var levelNode: SKNode!
    
    /* Camera helpers */
    var cameraTarget: SKNode?
    
//    let right = SKAction.moveByX(64, y: 0, duration: 0.6)
//    let left = SKAction.moveByX(-64, y: 0, duration: 0.6)
//    let up = SKAction.moveByX(0, y: 64, duration: 0.6)
//    let down = SKAction.moveByX(0, y: -64, duration: 0.6)
//    
//    func swipedRight(sender:UISwipeGestureRecognizer){
//        mainCharacter.runAction(right)
//    }
//    func swipedLeft(sender:UISwipeGestureRecognizer){
//        mainCharacter.runAction(left)
//    }
//    func swipedUp(sender:UISwipeGestureRecognizer){
//        mainCharacter.runAction(up)
//    }
//    func swipedDown(sender:UISwipeGestureRecognizer){
//        mainCharacter.runAction(down)
//    }
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
     
        
//        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
//        swipeRight.direction = .Right
//        view.addGestureRecognizer(swipeRight)
//        
//        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
//        swipeLeft.direction = .Left
//        view.addGestureRecognizer(swipeLeft)
//        
//        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
//        swipeUp.direction = .Up
//        view.addGestureRecognizer(swipeUp)
//        
//        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
//        swipeDown.direction = .Down
//        view.addGestureRecognizer(swipeDown)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch */
            let location = touch.locationInNode(self)
            
            if location.x > mainCharacter.parent?.convertPoint(mainCharacter.position, toNode: self).x {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(20, 0))
            } else {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(-20, 0))
            }
            
            if location.y > size.height / 2 {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(0, 20))
            }
            
            cameraTarget = mainCharacter
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x+50, y:camera!.position.y)
            
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 300)
            
            /* Check penguin has come to rest */
            if cameraTarget.physicsBody?.joints.count == 0 && cameraTarget.physicsBody?.velocity.length() < 0.15 || cameraTarget.position.x > 1100 || cameraTarget.position.x < 50 {
            
                let cameraReset = SKAction.moveTo(CGPoint(x:284, y:camera!.position.y), duration: 1.5)
                let cameraDelay = SKAction.waitForDuration(0.5)
                let cameraSequence = SKAction.sequence([cameraDelay,cameraReset])
                
                camera?.runAction(cameraSequence)
            }
            
            if mainCharacter.physicsBody?.velocity.length() > 25 {
                
                mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
                
            } else {
                
                mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moved */
        
        /* There will only be one touch as multi touch is not enabled by default */
//        for touch in touches {
//            
//            //Grab scene position of touch and update touchNode position
//            let location = touch.locationInNode(self)
//            //touchNode.position = location
//            
//        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ended */
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        if contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8 {
            
            print("hit")
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = Jungle(fileNamed:"Jungle") as Jungle!
            
            /* Ensure correct aspect mode (iPhone + iPad) */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
}
