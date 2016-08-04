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
    var boar: SKSpriteNode!
    
    var cameraTarget: SKNode?
    
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    
    /* Will move character only if this is true */
    var stillTouching: Bool = false
    
    var spawnTimer: CFTimeInterval = 0
    
    var moneyCount = 0
    var moneyCountLabel: SKLabelNode!
    
    var canJump: Bool = true
    
    var sideTouched: Side = .None
    
    var jumpButton: MSButtonNode!
    var moveLeftButton: SKSpriteNode!
    var moveRightButton: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.8);
        
        mainCharacter = self.childNodeWithName("//mainCharacter") as! SKSpriteNode
        
        moneyCountLabel = self.childNodeWithName("//moneyCountLabel") as! SKLabelNode
        
        jumpButton = self.childNodeWithName("//jumpButton") as! MSButtonNode
        
        moveLeftButton = self.childNodeWithName("//moveLeftButton") as! SKSpriteNode
        
        moveRightButton = self.childNodeWithName("//moveRightButton") as! SKSpriteNode
        
        for trees in self["treeSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("MonkeyTree1", ofType: "sks")
            let newTree = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            trees.addChild(newTree)
        }
        
        for moneyBags in self["moneyBagSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("MoneyBag", ofType: "sks")
            let moneyRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            moneyBags.addChild(moneyRef)
        
        }
        
        for flyingMoney in self["flyingMoneySpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("FlyingMoney", ofType: "sks")
            let flyingMoneyRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            flyingMoney.addChild(flyingMoneyRef)
        }
        
        for tigers in self["tigerSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("Tiger", ofType: "sks")
            let tigerRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            tigers.addChild(tigerRef)
        }
        
        for boars in self["boarSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("Boar", ofType: "sks")
            let boarRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            boars.addChild(boarRef)
            
            if let newBoar = boarRef.children[0].children[0] as? Boar {
                newBoar.Patrol()
            }
        }
        
        for snakes in self["snakeSpawn"] {
            
            let resourcePath = NSBundle.mainBundle().pathForResource("Snake", ofType: "sks")
            let snakeRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            snakes.addChild(snakeRef)
            
            if let newSnake = snakeRef.children[0].children[0] as? Snake {
                newSnake.Jump()
            }
        }
        
         /* Setup jump button selection handler */
         jumpButton.selectedHandler = {
            
            if self.canJump {
            
                self.mainCharacter.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch */
            let location = touch.locationInNode(self)
            
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode.name == "moveRightButton" {
                
                /* Allows charcter movement left/right */
                stillTouching = true
                sideTouched = .Right
                mainCharacter.physicsBody?.applyAngularImpulse(-0.000725)
                
            } else if touchedNode.name == "moveLeftButton" {
                
                /* Allows charcter movement left/right */
                stillTouching = true
                sideTouched = .Left
                mainCharacter.physicsBody?.applyAngularImpulse(0.000725)
                
//           } else if touchedNode.name == "jumpButton" {
//                
//                if self.canJump {
//                    
//                    self.mainCharacter.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12))
//                }
            }
            
            /* With each touch, set the camera to target mainCharacter */
            
            //this makes the slight jerk at the beginning happen
            
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
            camera?.position = CGPoint(x:cameraTarget.position.x + 284, y:cameraTarget.position.y + 100)
            
            /* Clamp camera scrolling to our visible scene area only */
            if cameraTarget.position.x < 0 {
                
                camera?.position.x.clamp(284, 500)
                
            } else if cameraTarget.position.x > 0 {
                
                camera?.position.x.clamp(284, cameraTarget.position.x + 150)
            }
            
            camera?.position.y.clamp(160, 500)
        }
        
        let velocityX = mainCharacter.physicsBody?.velocity.dx ?? 0
        
        /* Check and cap velocity */
        if velocityX > 210 {
            
            mainCharacter.physicsBody?.velocity.dx = 210
        } else if velocityX < -210 {
            
            mainCharacter.physicsBody?.velocity.dx = -210
        }
        
        if mainCharacter.physicsBody?.velocity.length() > 150 {
            
            mainCharacter.texture = SKTexture(imageNamed: "rollingFaceEmojiGame")
            
        } else {
            
            mainCharacter.texture = SKTexture(imageNamed: "mainCharacterEmojiGame")
        }
        
        spawnTimer+=fixedDelta
        
        if spawnTimer >= 4 {
            
            /* Every 4 seconds, spawn a bomb/bananaas! */
            monkeyThrow()
            spawnTimer = 0
        }
        
        moveChar()
        
        /* Additional character dampers */
        if mainCharacter.physicsBody?.velocity.dx != 0 && mainCharacter.physicsBody?.velocity.dy == 0 && !stillTouching {
            
            mainCharacter.physicsBody?.linearDamping = 1.0
            mainCharacter.physicsBody?.friction = 1.0
        } else {
            mainCharacter.physicsBody?.linearDamping = 0.2
            mainCharacter.physicsBody?.friction = 0.2
        }
        
        if self.mainCharacter.physicsBody?.velocity.dy < 60 && self.mainCharacter.physicsBody?.velocity.dy > -60 && mainCharacter.position.y < 80 {
        //or do sincetouch
            
            self.canJump = true
            
        } else {
            
            self.canJump = false
        }
    }
    
    func moveChar() {
    /* Touch & hold to move using boolean values */
        
        /* Default set to false */
        if stillTouching {
            
            cameraTarget = mainCharacter
            
            if sideTouched == .Right {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(8, 0))
            }
                
            else if sideTouched == .Left {
                
                mainCharacter.physicsBody?.applyForce(CGVectorMake(-8, 0))
            }
        }
    }
    
    func monkeyThrow() {
        
        for monkey in self["//monkey"] as! [SKSpriteNode] {
            
            /* Spawn bananas */
            let resourcePath = NSBundle.mainBundle().pathForResource("Bomb", ofType: "sks")
            
            /* This is a reference node. To get the physics of the Bomb.sks, need to
             access bombRef's grandchild */
            let bombRef = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
            
            let triggerTime = (Int64(NSEC_PER_SEC) * Int64((arc4random() % 4) ))
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.addChild(bombRef)
                
                /* Convert the monkey's coords to the main scene; place bomb there */
                bombRef.position = self.convertPoint(monkey.position, fromNode: monkey.parent!)
                
                let newBomb = bombRef.children[0].children[0]
                newBomb.physicsBody?.mass = 0.01
                
                let divisor: Float = 100.0
                let rand = Float((Int(arc4random() % 30)) - 15)
                let randomXdir = CGFloat(rand/divisor)
                
                newBomb.runAction(SKAction.applyAngularImpulse(CGFloat(0.0003), duration: 2))
                newBomb.runAction(SKAction.applyImpulse(CGVector(dx: randomXdir, dy: 1.8), duration: 1))
                newBomb.runAction(SKAction.applyForce(CGVector(dx: 0, dy: 6), duration: 6))
                
                newBomb.physicsBody!.restitution = 0
            })
        }
    }
    
    func fadeOut(node: SKNode) {
    /* Fade a node's opacity to zero (invisible) then remove it from its parent (scene) */
        
        //REFERENCE NODES DO NOT HAVE PHYSICS
        node.physicsBody?.restitution = 0
        
        node.physicsBody?.allowsRotation = false
        
        node.physicsBody?.angularVelocity = 0
        
        let fade = SKAction.fadeOutWithDuration(0.3)
        
        let remove = SKAction.removeFromParent()
        
        node.runAction(SKAction.sequence([fade, remove]))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        /* Check physics bodies. ONLY TO BE CALLED ON REFERENCE NODES! (Use category bitmask 
         of 2 for things that being spawned with reference nodes.*/
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            
            /* Fade out & removes the reference nodes */
            if contactA.categoryBitMask == 2 { fadeOut(nodeA.parent!.parent!) }
            if contactB.categoryBitMask == 2 { fadeOut(nodeB.parent!.parent!) }
        }
        
        /* Player/enemy interaction */
        if contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2 {
            
            if contactA.categoryBitMask == 2 {
                
                if contact.contactPoint.y > (self.convertPoint(nodeA.position, fromNode: nodeA.parent!)).y + nodeA.size.height/4 {
                    
                    print("enemy killed")
                    nodeA.physicsBody?.contactTestBitMask = 0
                    nodeA.physicsBody?.categoryBitMask = 0
                    
                    mainCharacter.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 17))
                    
                } else {
                    
                    /* Grab reference to our SpriteKit view */
                    let skView = self.view as SKView!
                    
                    /* Load Game scene */
                    let scene = Jungle(fileNamed:"Jungle") as Jungle!
                    
                    /* Ensure correct aspect mode (iPhone + iPad) */
                    scene.scaleMode = .AspectFit
                    
                    /* Show debug */
                    //skView.showsPhysics = true
                    skView.showsDrawCount = true
                    skView.showsFPS = true
                    
                    /* Start game scene */
                    skView.presentScene(scene)
                }
            }
            
            if contactB.categoryBitMask == 2 {
                
                if contact.contactPoint.y > (self.convertPoint(nodeB.position, fromNode: nodeB.parent!)).y + nodeB.size.height/4 {
                    
                    print("enemy killed")
                    nodeB.physicsBody?.contactTestBitMask = 0
                    nodeB.physicsBody?.categoryBitMask = 0
                    mainCharacter.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 17))

                } else {
                    
                    /* Grab reference to our SpriteKit view */
                    let skView = self.view as SKView!
                    
                    /* Load Game scene */
                    let scene = Jungle(fileNamed:"Jungle") as Jungle!
                    
                    /* Ensure correct aspect mode (iPhone + iPad) */
                    scene.scaleMode = .AspectFit
                    
                    /* Show debug */
                    //skView.showsPhysics = true
                    skView.showsDrawCount = true
                    skView.showsFPS = true
                    
                    /* Start game scene */
                    skView.presentScene(scene)
                }
            }
        }
        
        
        /* Player banana/money contact */
        if contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8 || contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1 {
            
            //if it's a banana, do something good (add to inventory)
            //no. get the money value from the node when it contacts. dont just write "5"
            moneyCount = moneyCount + 5
            
            moneyCountLabel.text = "💲 " + String(moneyCount)
            
            if contactA.categoryBitMask == 8 { fadeOut(nodeA.parent!.parent!) }
            if contactB.categoryBitMask == 8 { fadeOut(nodeB.parent!.parent!) }
            
            //show an animation next to character (+5) ?
        }
        
        if contactA.categoryBitMask == 16 && contactB.categoryBitMask == 1 || contactA.categoryBitMask == 1 && contactB.categoryBitMask == 16 {
            
            if let scene = GameScene(fileNamed:"GameScene") {
                // Configure the view.
                let skView = self.view! 
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
    }
}