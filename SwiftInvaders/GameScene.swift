//
//  GameScene.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 24/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    
    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isShooting: Bool = false

    
    override func didMoveToView(view: SKView) {
        if let childNode = self.childNodeWithName("player") as? SKSpriteNode {
            self.player = childNode
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
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
}
