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
    
    let fixedDelta: CFTimeInterval = 6.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 160
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
        /* Set reference to scroll layer node */
        scrollLayer = self.childNodeWithName("scrollLayer")

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
            let location = touch.locationInView(view)
            
            if location.x > size.width / 2 {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(20, 0))
            } else {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(-20, 0))
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        scrollJungle()
    }
    
    func scrollJungle() {
        
        /* Scroll World */
        //scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convertPoint(ground.position, toNode: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPointMake( (self.size.width / 2) + ground.size.width, groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convertPoint(newPosition, toNode: scrollLayer)
            }
        }
        
    }
    
}