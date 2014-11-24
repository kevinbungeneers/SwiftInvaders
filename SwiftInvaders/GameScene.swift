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

    var shot: SKSpriteNode = SKSpriteNode(imageNamed: "laserRed01")
    
    var lastShotFired: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        if let childNode = self.childNodeWithName("player") as? SKSpriteNode {
            self.player = childNode
        }
        
        if let children = GameScene.unarchiveFromFile("Level1")?.children {
            for child: AnyObject in children {
                self.addChild(child.copy() as SKNode)
            }
        }
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
            shotPosition!.y += 65
            let newShot = shot.copy() as SKSpriteNode
            newShot.position = shotPosition!
            self.addChild(newShot)
            
            let action: SKAction = SKAction.moveByX(0, y: 600, duration: 1.0)
            newShot.runAction(SKAction.repeatActionForever(action))
            self.lastShotFired = currentTime;
        }
    }
}
