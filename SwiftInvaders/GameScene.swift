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
        self.player.update(currentTime)
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
            self.player.isMovingLeft = active
        case 124:
            self.player.isMovingRight = active
        case 49:
            self.player.isShooting = active
        default:
            ()
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
