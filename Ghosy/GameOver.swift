//
//  GameOver.swift
//  Ghosy
//
//  Created by Gennaro Cirillo on 23/03/22.
//

import Foundation
import SpriteKit

class GameOver : SKScene{
    
    override func didMove(to view: SKView) {
        
        let star: SKSpriteNode = SKSpriteNode(imageNamed: "background1")
        star.zPosition = 1
        star.xScale = size.width * 0.002
        star.yScale = size.width * 0.002
        star.position =  CGPoint(x: self.frame.size.width * 0.5 , y: self.frame.size.height * 0.5)
        addChild(star)
        
        let backgroundGradiente: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
        backgroundGradiente.position = CGPoint(x: self.frame.size.width * 0.5 , y: self.frame.size.height * 0.5)
        backgroundGradiente.xScale = size.width
        backgroundGradiente.yScale = size.width * 0.002
        backgroundGradiente.zPosition = 0
        addChild(backgroundGradiente)
        
        let sconfitta: SKSpriteNode = SKSpriteNode(imageNamed: "game over")
        sconfitta.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        sconfitta.xScale = frame.size.width * 0.0007
        sconfitta.yScale = frame.size.width * 0.0007
        sconfitta.zPosition = 2
        addChild(sconfitta)
    }
    
}
