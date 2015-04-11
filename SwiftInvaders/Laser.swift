//
//  Laser.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 28/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

class Laser: Entity {
    
    convenience init() {
        self.init(spriteName: "laserRed01")
    }
    
    
    override init(spriteName: String) {
        super.init(spriteName: spriteName)
        
        self.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: self.sprite.size)
        self.sprite.physicsBody?.categoryBitMask = CollisionType.Bullet.rawValue
        self.sprite.physicsBody?.collisionBitMask = 0
        self.sprite.physicsBody?.affectedByGravity = false
        self.sprite.physicsBody?.contactTestBitMask = CollisionType.Edge.rawValue
    }
    
    internal func fire(position: CGPoint, parent: SKNode) {
        let copy = self.sprite.copy() as! SKSpriteNode
        copy.position = position
        parent.addChild(copy)
        let action: SKAction = SKAction.moveByX(0, y: 600, duration: 1.0)
        copy.runAction(SKAction.repeatActionForever(action))
    }
    
}
