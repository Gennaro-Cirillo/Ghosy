//
//  play.swift
//  Ghosy
//
//  Created by Guendalina De Laurentis on 24/03/22.
//

import Foundation
import SpriteKit

class Play  : SKScene{
    
    
    override func didMove(to view: SKView) {
        let backgroundGradiente: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
        backgroundGradiente.position = CGPoint(x: self.frame.size.width * 0.5 , y: self.frame.size.height * 0.5)
        backgroundGradiente.xScale = size.width
        backgroundGradiente.yScale = size.width * 0.002
        backgroundGradiente.zPosition = 0
        addChild(backgroundGradiente)
        
        let star: SKSpriteNode = SKSpriteNode(imageNamed: "starsFlow")
        let star1: SKSpriteNode = SKSpriteNode(imageNamed: "starsFlow")
        star.position = CGPoint(x: self.frame.size.width * 1.1, y: self.frame.size.height * 0.6)
        star1.position = CGPoint(x: -self.frame.size.width * 0.1, y: self.frame.size.height * 0.6)
        star.xScale = frame.size.width * 0.0018
        star.yScale = frame.size.width * 0.0018
        star.alpha = 0.6
        star.zPosition = 0
        star1.xScale = frame.size.width * 0.0018
        star1.yScale = frame.size.width * 0.0018
        star1.alpha = 0.6
        star1.zPosition = 0
        addChild(star)
        addChild(star1)

        let prop1: SKSpriteNode = SKSpriteNode(imageNamed: "grave1-1.png")
        prop1.position = CGPoint(x: frame.size.width/5, y: frame.size.height/3.5)
        prop1.zPosition = 1
        prop1.xScale = frame.size.width * 0.0007
        prop1.yScale = frame.size.height * 0.0015
        addChild(prop1)
        
        let prop2: SKSpriteNode = SKSpriteNode(imageNamed: "grave1-3.png")
        prop2.position = CGPoint(x: frame.size.width/1.3, y: frame.size.height/3.5)
        prop2.zPosition = 1
        prop2.xScale = frame.size.width * 0.0007
        prop2.yScale = frame.size.height * 0.0015
        addChild(prop2)
        
        let base: SKSpriteNode = SKSpriteNode(imageNamed: "grave1-5.png")
        base.position = CGPoint(x: frame.size.width/2, y: frame.size.height/5)
        base.zPosition = 0
        base.xScale = frame.size.width
        addChild(base)
        
        let play: SKSpriteNode = SKSpriteNode(imageNamed: "PLAY")
        play.position = CGPoint(x: size.width*0.5, y: size.height*0.25)
        play.xScale = frame.size.width * 0.0008
        play.yScale = frame.size.width * 0.0008
        play.zPosition = 2
        play.name = "tapToPlay"
        addChild(play)
        let ghosy: SKSpriteNode = SKSpriteNode(imageNamed: "ghosy")
        ghosy.position = CGPoint(x: size.width*0.5, y: size.height*0.6)
        ghosy.xScale = frame.size.width * 0.0008
        ghosy.yScale = frame.size.width * 0.0008
        ghosy.zPosition = 1
        addChild(ghosy)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
//
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "tapToPlay"){
            let startGameScene = GameScene(size: self.size)
            self.view?.presentScene(startGameScene)
        }
    }
    

}

