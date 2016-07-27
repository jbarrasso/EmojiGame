//
//  Jungle.swift
//  EmojiGame
//
//  Created by Jeffrey Barrasso on 7/14/16.
//  Copyright © 2016 Jeff Barrasso. All rights reserved.
//

import Foundation

import SpriteKit

import UIKit


class Jungle: SKScene, SKPhysicsContactDelegate/*, UIGestureRecognizerDelegate */{
    
    var mainCharacter: SKSpriteNode!
    var cameraTarget: SKNode?
    
    let fixedDelta: CFTimeInterval = 6.0/60.0 /* 60 FPS */
    
    /* Will move character only if this is true */
    var stillTouching: Bool = false
    
    var spawnTimer: CFTimeInterval = 0
    
    var moneyCount = 0
    var moneyCountLabel: SKLabelNode!
    
    var sideTouched: Side = .None
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.8);
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
        moneyCountLabel = self.childNodeWithName("//moneyCountLabel") as! SKLabelNode
        
        //        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector(self.moveChar()))
        //
        //        longPressRecognizer.minimumPressDuration = 0.5
        //        longPressRecognizer.delegate = self
        
        
        for trees in self["treeSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("MonkeyTree1", ofType: "sks")
            let newTree = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            trees.addChild(newTree)
        }
        
        for moneyBags in self["moneyBagSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("MoneyBag", ofType: "sks")
            let moneyRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            moneyBags.addChild(moneyRef)
            
            //wrong. do a separate empty node thing
//            if moneyRef.parent!.position.y > size.height / 2 {
//                
//                let flyingMoney = moneyRef.children[0].children[0] as! SKSpriteNode
//                flyingMoney.texture = SKTexture(imageNamed: "flyingMoneyEmojiGame")
//            }
        }
        
        for flyingMoney in self["flyingMoneySpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("FlyingMoney", ofType: "sks")
            let newFlyingMoney = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            flyingMoney.addChild(newFlyingMoney)
        }
        
        for tigers in self["tigerSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("Tiger", ofType: "sks")
            let newTiger = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            tigers.addChild(newTiger)
        }
        
        for boars in self["boarSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("Boar", ofType: "sks")
            let newBoar = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            boars.addChild(newBoar)
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
            } else {
                
                sideTouched = .Left
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
            let stoppingForce = (mainCharacter.physicsBody?.velocity.dx)! / 65
            let reverseRotation = (mainCharacter.physicsBody?.angularVelocity)! / 10000
            
            mainCharacter.physicsBody?.applyAngularImpulse(-reverseRotation)
            mainCharacter.physicsBody?.applyImpulse(CGVectorMake(-stoppingForce, 0))
            
        } else if mainCharacter.physicsBody?.velocity.dx < 0 {
            
            let stoppingForce = (mainCharacter.physicsBody?.velocity.dx)! / 65
            let reverseRotation = (mainCharacter.physicsBody?.angularVelocity)! / 10000
            
            mainCharacter.physicsBody?.applyAngularImpulse(-reverseRotation)
            mainCharacter.physicsBody?.applyImpulse(CGVectorMake(-stoppingForce, 0))
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
            
            /* Fade out & remove banana */
            if contactA.categoryBitMask == 2 { fadeOut(nodeA) }
            if contactB.categoryBitMask == 2 { fadeOut(nodeB) }
        }
        
        /* Player death */
        if contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2 {
            
            //            /* Grab reference to our SpriteKit view */
            //            let skView = self.view as SKView!
            //
            //            /* Load Game scene */
            //            let scene = Jungle(fileNamed:"Jungle") as Jungle!
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
        }
        
        /* Player banana/money contact */
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8 || contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1 {
            
            //if it's a banana, do something good (add to inventory)
            //no. get the money value from the node when it contacts. dont just write "5"
            moneyCount = moneyCount + 5
            
            moneyCountLabel.text = "💲 " + String(moneyCount)
            
            if contactA.categoryBitMask == 8 { fadeOut(nodeA) }
            if contactB.categoryBitMask == 8 { fadeOut(nodeB) }
            
            //show an animation next to character (+5) ?
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        /* Check we have a valid camera target to follow */
        if let cameraTarget = cameraTarget {
            
            /* Set camera position to follow target horizontally, keep vertical locked */
            camera?.position = CGPoint(x:cameraTarget.position.x+100, y:camera!.position.y)
            
            /* Clamp camera scrolling to our visible scene area only */
            camera?.position.x.clamp(283, 3000)
        }
        
        let velocityX = mainCharacter.physicsBody?.velocity.dx ?? 0
        
        /* Check and cap velocity */
        if velocityX > 195 {
            
            mainCharacter.physicsBody?.velocity.dx = 195
        } else if velocityX < -195 {
            
            mainCharacter.physicsBody?.velocity.dx = -195
        }
        
        if mainCharacter.physicsBody?.velocity.length() > 25 {
            
            mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
            
        } else {
            
            mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
        }
        
        spawnTimer+=fixedDelta
        
        /* Every 4 seconds, spawn a bomb/banana */
        if spawnTimer >= 4 {
            
            monkeyThrow()
            spawnTimer = 0
        }
        
        moveChar()
        
        /* Additional character dampers */
        if mainCharacter.physicsBody?.velocity.dx != 0 && !stillTouching {
            
            mainCharacter.physicsBody?.linearDamping = 1.0
            mainCharacter.physicsBody?.friction = 1.0
        } else {
            mainCharacter.physicsBody?.linearDamping = 0.2
            mainCharacter.physicsBody?.friction = 0.2
        }
    }
    
    func moveChar() {
    /* Touch & hold to move using boolean values */
        
        /* Default set to false */
        if stillTouching {
            
            if sideTouched == .Right {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(6, 0))
            }
                
            else if sideTouched == .Left {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(-6, 0))
            }
        }
    }
    
    func monkeyThrow() {
        
        for monkey in self["//monkey"] as! [SKSpriteNode] {
            
            /* Spawn bananas */
            let resourcePath = NSBundle.mainBundle().pathForResource("Bomb", ofType: "sks")
            
            /* This is a reference node. To get the physics of the Banana.sks, need to 
             access bananaRef's grandchild, which is the actual banana with physics */
            let bananaRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            self.addChild(bananaRef)
            
            /* Convert the monkey's coords to the main scene; place banana there */
            bananaRef.position = self.convertPoint(monkey.position, fromNode: monkey.parent!)
            
            //Implement random throwing. bombs highest, banana medium, gem rare
            
            let myBanana = bananaRef.children[0].children[0]
            myBanana.runAction(SKAction.applyImpulse(CGVector(dx: 1, dy: 100), duration: 1))
            myBanana.runAction(SKAction.applyAngularImpulse(CGFloat(0.025), duration: 2))
            myBanana.physicsBody!.restitution = 0
        }
    }
    
    func fadeOut(node: SKNode) {
    /* Fade a node's opacity to zero (invisible) then remove it from its parent (scene) */
        
        node.physicsBody?.restitution = 0
        
        node.physicsBody?.allowsRotation = false
        
        node.physicsBody?.angularVelocity = 0
        
        let fade = SKAction.fadeOutWithDuration(0.5)
       
        let remove = SKAction.runBlock({
            
            /* Remove node from scene */
            node.removeFromParent()
        })
        
        node.runAction(SKAction.sequence([fade, remove]))
    }
}