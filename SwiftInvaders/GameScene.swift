//
//  GameScene.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 24/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

enum CollisionType: UInt32 {
    case Edge   = 1
    case Player = 2
    case Bullet = 4
    case Enemy  = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode?
    
    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isShooting: Bool = false

    var shot: SKSpriteNode = SKSpriteNode(imageNamed: "laserRed01")
    
    var lastShotFired: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        /* Initialize physics for scene */
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = CollisionType.Edge.rawValue
        
        /* Intialize physics for a single shot */
        shot.physicsBody = SKPhysicsBody(rectangleOfSize: shot.size)
        shot.physicsBody?.categoryBitMask = CollisionType.Bullet.rawValue
        shot.physicsBody?.collisionBitMask = 0 // Make sure the bullet isn't affected by the collision
        shot.physicsBody?.affectedByGravity = false
        shot.physicsBody?.contactTestBitMask = CollisionType.Edge.rawValue
        
        /* Add player + enemies to scene. Both have their physics settings defined in the SKS file */
        if let childNode = self.childNodeWithName("player") as? SKSpriteNode {
            self.player = childNode
        }
        
        if let children = GameScene.unarchiveFromFile("Level1")?.children {
            let enemyGroup: SKNode = SKNode()
            for child: AnyObject in children {
                child.physicsBody??.categoryBitMask = CollisionType.Enemy.rawValue
                child.physicsBody??.collisionBitMask = 0
                child.physicsBody??.contactTestBitMask = CollisionType.Bullet.rawValue
                enemyGroup.addChild(child.copy() as SKNode)
            }
            self.addChild(enemyGroup)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.handleMovement()
        self.handleShooting(currentTime)
    }
    
    override func keyDown(theEvent: NSEvent) {
        self.handleInput(theEvent.keyCode, active: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        self.handleInput(theEvent.keyCode, active: false)
    }
    
    func handleInput(keyCode: UInt16, active: Bool) {
        switch keyCode {
        case 123:
            self.isMovingLeft = active
        case 124:
            self.isMovingRight = active
        case 49:
            self.isShooting = active
        default:
            ()
        }
    }
    
    func handleMovement() {
        /* Handle movement, like a boss */
        var newPosition = self.player?.position
        if self.isMovingLeft {
            newPosition!.x -= 10
            if newPosition!.x < (self.player?.frame.width)! / 2 {
                newPosition!.x = (self.player?.frame.width)! / 2
            }
        }
        
        if self.isMovingRight {
            newPosition!.x += 10
            if newPosition!.x > (self.frame.width - (self.player?.frame.width)! / 2) {
                newPosition!.x = self.size.width - (self.player?.frame.width)! / 2
            }
        }
        
        self.player?.position = newPosition!
    }
    
    func handleShooting(currentTime: CFTimeInterval) {
        /* Handle shooting, like a boss */
        if self.isShooting && (currentTime - self.lastShotFired > 0.3) {
            var shotPosition = self.player?.position
            shotPosition!.y += 70
            
            let newShot = shot.copy() as SKSpriteNode
            newShot.position = shotPosition!
            self.addChild(newShot)
            
            let action: SKAction = SKAction.moveByX(0, y: 600, duration: 1.0)
            newShot.runAction(SKAction.repeatActionForever(action))
            self.lastShotFired = currentTime;
        }
    }
}
