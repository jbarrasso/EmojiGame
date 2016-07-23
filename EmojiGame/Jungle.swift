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

    var mainCharacter: SKSpriteNode!

    var cameraTarget: SKNode?
    
    let fixedDelta: CFTimeInterval = 6.0/60.0 /* 60 FPS */

    var spawnTimer: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.8);
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode

        for trees in self["treeSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("MonkeyTree1", ofType: "sks")
            let newTree = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            trees.addChild(newTree)
        }
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
            
//            if location.y > size.height / 2 {
//                
//                mainCharacter.physicsBody?.applyForce(CGVectorMake(0, 20))
//            }
            
            cameraTarget = mainCharacter
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x+50, y:camera!.position.y)
            
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 3000)
        }
        
        if mainCharacter.physicsBody?.velocity.length() > 25 {
            
            mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
            
        } else {
    
            mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
        }
        
        spawnTimer+=fixedDelta
    
        if spawnTimer >= 4 {
        
            flingBananas()
            spawnTimer = 0
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        /* Check if either physics bodies was a banana */
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            
            /* Delete banana */
            if contactA.categoryBitMask == 2 { fadeOut(nodeA) }
            if contactB.categoryBitMask == 2 { fadeOut(nodeB) }
        }
        
        if contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2 {
            
            print("banana/player contact")
        }
    }

    func flingBananas() {
        
        for monkey in self["//monkey"] as! [SKSpriteNode] {
            
            /* Spawn bananas */
            let resourcePath = NSBundle.mainBundle().pathForResource("Banana", ofType: "sks")
            let bananaRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            self.addChild(bananaRef)
            bananaRef.position = self.convertPoint(monkey.position, fromNode: monkey.parent!)

            let myBanana = bananaRef.children[0].children[0]
            myBanana.runAction(SKAction.applyImpulse(CGVector(dx: 1, dy: 100), duration: 1))
            myBanana.runAction(SKAction.applyAngularImpulse(CGFloat(0.025), duration: 2))
            myBanana.physicsBody!.restitution = 0
        }
    }
    
    func fadeOut(node: SKNode) {
        
        node.physicsBody?.restitution = 0
        
        node.physicsBody?.allowsRotation = false
        
        node.physicsBody?.angularVelocity = 0
        
        let fade = SKAction.fadeOutWithDuration(0.5)
        
        /* Create our hero death action */
        let remove = SKAction.runBlock({
            /* Remove seal node from scene */
            node.removeFromParent()
        })
        
        node.runAction(SKAction.sequence([fade, remove]))
    }
}