//
//  GameOver.swift
//  Ghosy
//
//  Created by Gennaro Cirillo on 23/03/22.
//

import Foundation
import SpriteKit

class GameOver : SKScene{
    
    let gameOver = SKLabelNode(text: "GAME OVER")
    let bestScore = SKLabelNode(text: "BEST SCORE:")
    let tapToPlay = SKLabelNode(text: "Tap to play")
    
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
  
        gameOver.position = CGPoint (x: frame.size.width/2, y: frame.size.height/2.5)
        gameOver.fontSize = 35
        gameOver.fontName = "Minecraft"
        gameOver.fontColor = .init(hue: 0.76, saturation: 0.12, brightness: 0.69, alpha: 1)
        gameOver.zPosition = 11
        addChild(gameOver)
        
        bestScore.position = CGPoint (x: frame.size.width/2, y: frame.size.height/3.5)
        bestScore.fontSize = 25
        bestScore.fontName = "Minecraft"
        bestScore.fontColor = .init(hue: 0.76, saturation: 0.12, brightness: 0.69, alpha: 1)
        bestScore.zPosition = 11
        addChild(bestScore)
        
        tapToPlay.position = CGPoint (x: frame.size.width/2, y: frame.size.height/9.5)
        tapToPlay.fontSize = 20
        tapToPlay.fontName = "Minecraft"
        tapToPlay.fontColor = .init(hue: 0.76, saturation: 0.12, brightness: 0.69, alpha: 1)
        tapToPlay.zPosition = 11
        tapToPlay.name = "tapToContinue"
        addChild(tapToPlay)
        
        let sconfitta: SKSpriteNode = SKSpriteNode(imageNamed: "game over")
        sconfitta.position = CGPoint(x: size.width*0.5, y: size.height*0.73)
        sconfitta.xScale = frame.size.width * 0.003
        sconfitta.yScale = frame.size.width * 0.003
        sconfitta.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "game over") , SKTexture(imageNamed:"game over 2")], timePerFrame: 0.25)))
        sconfitta.zPosition = 2
        addChild(sconfitta)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
//
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if(touchedNode.name == "tapToContinue"){
            let startGameScene = GameScene(size: self.size)
            self.view?.presentScene(startGameScene)
        }
    }
    
}
