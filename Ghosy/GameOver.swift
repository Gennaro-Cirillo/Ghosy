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
        
        backgroundColor = .black
        
        let sconfitta = SKLabelNode(text: "Game Over")
        sconfitta.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(sconfitta)
    }
    
}
