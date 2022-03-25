//
//  Win.swift
//  Ghosy
//
//  Created by Gennaro Cirillo on 24/03/22.
//

import Foundation
import SpriteKit

class Win : SKScene{
    
    let vittoria : SKLabelNode = SKLabelNode(text: "Hai Vinto")

    
    override func didMove(to view: SKView) {
        
        vittoria.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        addChild(vittoria)
        
    }
}
