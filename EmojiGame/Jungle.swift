//
//  Jungle.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/14/16.
//  Copyright © 2016 Jeff Barrasso. All rights reserved.
//

import Foundation

import SpriteKit

class Jungle: SKScene, SKPhysicsContactDelegate {
    
    /* UI Connections */
    //var buttonPlay: MSButtonNode!
    var mainCharacter: SKSpriteNode!
    
    var scrollLayer: SKNode!
    
    var SKSpriteNode_1: SKSpriteNode!
    
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 160
    
    var levelNode: SKNode!
    
    var cameraTarget: SKNode?
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
        /* Set reference to scroll layer node */
        scrollLayer = self.childNodeWithName("scrollLayer")
        
        SKSpriteNode_1 = self.childNodeWithName("//SKSpriteNode_1") as! SKSpriteNode
        
        levelNode = childNodeWithName("//levelNode")
        
        /* Load Level 1 */
        let resourcePath = NSBundle.mainBundle().pathForResource("MonkeyTree1", ofType: "sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)

//        /* Setup your scene here */
//        
//        /* Set UI connections */
//        buttonPlay = self.childNodeWithName("buttonPlay") as! MSButtonNode
//        
//        /* Setup restart button selection handler */
//        buttonPlay.selectedHandler = {
//            
//            /* Grab reference to our SpriteKit view */
//            let skView = self.view as SKView!
//            
//            /* Load Game scene */
//            let scene = GameScene(fileNamed:"GameScene") as GameScene!
//            
//            /* Ensure correct aspect mode (iPhone + iPad) */
//            scene.scaleMode = .AspectFit
//            
//            /* Show debug */
//            skView.showsPhysics = true
//            skView.showsDrawCount = true
//            skView.showsFPS = true
//            
//            /* Start game scene */
//            skView.presentScene(scene)
//        }
        
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
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x+50, y:camera!.position.y)
            
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 1200)
            
        }
        print(mainCharacter.physicsBody?.velocity.length())
        
        if mainCharacter.physicsBody?.velocity.length() > 25 {
            
            mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
            
        } else {
            
            mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
        }
    }
    
//    func scrollJungle() {
//        
//        /* Scroll World */
//        //scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
//        
//        /* Loop through scroll layer nodes */
//        for ground in scrollLayer.children as! [SKSpriteNode] {
//            
//            /* Get ground node position, cwionvert node position to scene space */
//            let groundPosition = scrollLayer.convertPoint(ground.position, toNode: self)
//            
//            /* Check if ground sprite has left the scene */
//            if (camera?.position.x)! - self.view!.frame.width / 2 >= ground.size.width {
//                
//                print("hey")
//                
//                /* Reposition ground sprite to the second starting position */
//                let newPosition = CGPointMake( (self.size.width / 2) + ground.size.width * 2, groundPosition.y)
//                
//                /* Convert new node position back to scroll layer space */
//                ground.position = self.convertPoint(newPosition, toNode: scrollLayer)
//            }
//        }
//    }
}