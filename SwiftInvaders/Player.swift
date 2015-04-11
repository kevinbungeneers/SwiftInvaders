//
//  Player.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 28/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

class Player: Entity {
    
    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isShooting: Bool = false
    var lastShotFired: CFTimeInterval = 0
    var laser: Laser!

    override init(sprite: SKSpriteNode) {
        super.init(sprite: sprite)
        self.addThruster()
        self.laser = Laser()
    }
    
    internal func addThruster() {
        let thruster: SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Thruster", ofType: "sks")!) as! SKEmitterNode
        thruster.position.y = -40
        self.sprite.addChild(thruster)
    }
    
    override func update(currentTime: CFTimeInterval) {
        var currentPosition = self.sprite.position
        
        if let parent = self.sprite.parent {
            if self.isMovingLeft {
                currentPosition.x -= 10
                if currentPosition.x < (self.sprite.frame.width) / 2 {
                    currentPosition.x = (self.sprite.frame.width) / 2
                }
                self.sprite.position = currentPosition
            }
            
            if self.isMovingRight {
                currentPosition.x += 10
                if currentPosition.x > (parent.frame.width - (self.sprite.frame.width) / 2) {
                    currentPosition.x = parent.frame.width - (self.sprite.frame.width / 2)
                }
                self.sprite.position = currentPosition
            }
            
            if self.isShooting && (currentTime - self.lastShotFired > 0.3) {
                var shotPosition = self.sprite.position
                shotPosition.y += 70
                
                laser.fire(shotPosition, parent: parent)
                
                self.lastShotFired = currentTime;
            }

        }

        
    }

}
