//
//  GameScene.swift
//  SwiftInvaders
//
//  Created by Kevin Bungeneers on 24/11/14.
//  Copyright (c) 2014 Kevin Bungeneers. All rights reserved.
//

import SpriteKit



class GameScene: SKScene {
    

    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 36 {
            
            if let scene = GenericLevel.unarchiveFromFile("Level1") as? GenericLevel {
                scene.scaleMode = .AspectFill
                self.view!.presentScene(scene)
            }
        }
    }
}
