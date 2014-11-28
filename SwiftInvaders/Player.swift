//
//  Player.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 28/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

class Player: Entity {

    override init(sprite: SKSpriteNode) {
        super.init(sprite: sprite)
        self.addThruster()
    }
    
    internal func addThruster() {
        let thruster: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Thruster", ofType: "sks")!) as SKEmitterNode
        thruster.position.y = -40
        self.sprite.addChild(thruster)
    }
}
