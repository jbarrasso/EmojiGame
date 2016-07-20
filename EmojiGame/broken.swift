//
//  GameScene.swift
//  BrokenGame
//
//  Created by Jonathan  Fotland on 7/19/16.
//  Copyright (c) 2016 Make School. All rights reserved.
//
​
import SpriteKit
​
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scrollLayer: SKNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var scrollSpeed: CGFloat = 100.0
    let fixedDelta = 1/60
    var timer = 0
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scrollLayer = childNodeWithName("scroll")
        player = childNodeWithName("avatar") as! SKSpriteNode
        scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        
        physicsWorld.contactDelegate = self
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let target: Target
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 {
            target = bodyB.node as! Target
        } else {
            target = bodyA.node as! Target
        }
        
        target.die()
        score += 1
        
        /*
         if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4 ||
         bodyB.categoryBitMask == 1 && bodyA.categoryBitMask == 4 {
         //we died restart
         
         /* Grab reference to our SpriteKit view */
         let skView = self.view as SKView!
         
         /* Load Game scene */
         let scene = GameScene(fileNamed:"GameScene") as GameScene!
         
         /* Ensure correct aspect mode */
         scene.scaleMode = .AspectFill
         
         /* Restart GameScene */
         skView.presentScene(scene)
         
         } */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let playerLoc = player.position
            
            let vector = (location - playerLoc)
            
            let action = SKAction.applyImpulse(CGVector(point: vector), duration: 0.1)
            
            player.runAction(action)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        scrollWorld()
        timer += fixedDelta
        if (timer > 5) {
            addTarget()
        }
    }
    
    func addTarget() {
        let resourcePath = NSBundle.mainBundle().pathForResource("target", ofType: "sks")
        let newTarget = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        
        newTarget.position.x = 600
        newTarget.position.y = CGFloat(arc4random_uniform(500))
        
        scrollLayer.addChild(newTarget)
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
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