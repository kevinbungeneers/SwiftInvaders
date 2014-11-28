//
//  Entity.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 28/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

class Entity {
    
    let sprite: SKSpriteNode = SKSpriteNode()
    
    init(spriteName: String) {
        self.sprite = SKSpriteNode(imageNamed: spriteName)
    }
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
    
    internal func update(currentTime: CFTimeInterval) {
        
    }
}
