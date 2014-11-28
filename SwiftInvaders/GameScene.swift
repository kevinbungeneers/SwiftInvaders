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
    case EnemyGroup = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    
    let enemyGroup: SKNode = SKNode()
    var enemyGroupMovementSpeed: CGFloat = 3.0
    var dropEnemies: Bool = false
    let dropAction: SKAction = SKAction.moveByX(0, y: -10, duration: 0.3)

    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isShooting: Bool = false
    
    var lastShotFired: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        self.initializePhysics();
        
        if let childNode = self.childNodeWithName("player") as? SKSpriteNode {
            self.player = Player(sprite: childNode)
        }
        
        self.initializeParallaxBackground()
        self.loadLevel()
    }
    
    private func initializePhysics()
    {
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = CollisionType.Edge.rawValue
    }
    
    private func loadLevel() {
        if let children = GameScene.unarchiveFromFile("Level1")?.children {
            for child: AnyObject in children {
                let newChild = child.copy() as SKNode
                newChild.physicsBody?.categoryBitMask = CollisionType.Enemy.rawValue
                newChild.physicsBody?.collisionBitMask = 0
                newChild.physicsBody?.contactTestBitMask = CollisionType.Bullet.rawValue | CollisionType.Edge.rawValue
                enemyGroup.addChild(newChild)
            }
            self.addChild(enemyGroup)
        }
    }
    
    internal func didBeginContact(contact: SKPhysicsContact) {
        var first: SKPhysicsBody = contact.bodyA
        var second: SKPhysicsBody = contact.bodyB

        if first.categoryBitMask > second.categoryBitMask {
            second = contact.bodyA
            first = contact.bodyB
        }
        
        if first.categoryBitMask == CollisionType.Bullet.rawValue {
            if second.categoryBitMask == CollisionType.Enemy.rawValue {
                first.node?.removeFromParent()
                second.node?.removeFromParent()
            } else if second.categoryBitMask == CollisionType.Enemy.rawValue {
                first.node?.removeFromParent()
            }
        }
        
        if first.categoryBitMask == CollisionType.Edge.rawValue {
            if second.categoryBitMask == CollisionType.Enemy.rawValue {
                self.enemyGroupMovementSpeed *= -1
                self.dropEnemies = true
            }
        }
    }
    
    override internal func update(currentTime: CFTimeInterval) {
        self.handleMovement()
        self.handleShooting(currentTime)
        self.moveEnemies()
    }
    
    override internal func keyDown(theEvent: NSEvent) {
        self.handleInput(theEvent.keyCode, active: true)
    }
    
    override internal func keyUp(theEvent: NSEvent) {
        self.handleInput(theEvent.keyCode, active: false)
    }
    
    private func handleInput(keyCode: UInt16, active: Bool) {
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
        var newPosition = self.player.sprite.position
        if self.isMovingLeft {
            newPosition.x -= 10
            if newPosition.x < (self.player.sprite.frame.width) / 2 {
                newPosition.x = (self.player.sprite.frame.width) / 2
            }
        }
        
        if self.isMovingRight {
            newPosition.x += 10
            if newPosition.x > (self.frame.width - (self.player.sprite.frame.width) / 2) {
                newPosition.x = self.size.width - (self.player.sprite.frame.width) / 2
            }
        }
        
        self.player.sprite.position = newPosition
    }
    
    func handleShooting(currentTime: CFTimeInterval) {
        /* Handle shooting, like a boss */
        if self.isShooting && (currentTime - self.lastShotFired > 0.3) {
            var shotPosition = self.player.sprite.position
            shotPosition.y += 70
            
            let shot: Laser = Laser(position: shotPosition)
            self.addChild(shot.sprite)
            
            self.lastShotFired = currentTime;
        }
    }
    
    func moveEnemies() {
        self.enemyGroup.position.x = self.enemyGroup.position.x + self.enemyGroupMovementSpeed
        if self.dropEnemies {
            enemyGroup.runAction(dropAction)
            self.dropEnemies = false
        }
    }
    
    private func initializeParallaxBackground() {
        let background: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Background", ofType: "sks")!) as SKEmitterNode
        background.position = CGPointMake(self.size.width / 2, self.size.height)
        background.zPosition = -10
        background.advanceSimulationTime(10)
        self.addChild(background)
    }
}
