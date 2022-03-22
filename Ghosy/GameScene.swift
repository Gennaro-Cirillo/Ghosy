//
//  GameScene.swift
//  Ghosy
//
//  Created by Gennaro Cirillo on 22/03/22.
//

import SpriteKit
import GameplayKit

struct PhysicsCategories {
    static let fantasmino : UInt32 = 0x1 << 0
    static let pavimento : UInt32 = 0x1 << 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {

//    VARIABILI UTILI
    
    var cont: Int = 0
    
    
//    DICHIARAZIONI SPRITE
    
    
    let personaggio: SKSpriteNode = SKSpriteNode(imageNamed: "walkFrame1")
    let terreno: SKSpriteNode = SKSpriteNode(imageNamed: "base")
    let pilastro1: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle1")
    
    
    
    override func didMove(to view: SKView) {
        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        
        personaggio.position = CGPoint(x:400 , y:90)
        personaggio.name = "fantasmino"
        personaggio.xScale = 0.1
        personaggio.yScale = 0.1
        personaggio.physicsBody = SKPhysicsBody(texture: personaggio.texture!, size: personaggio.size)
        personaggio.physicsBody?.restitution = 0
        personaggio.physicsBody?.categoryBitMask = PhysicsCategories.fantasmino
        personaggio.physicsBody?.contactTestBitMask = PhysicsCategories.pavimento
        
        
        
//      terreno(aka pavimento)
        
        terreno.position = CGPoint(x: size.width*0.5 ,y: 0)
        terreno.xScale = 2
        terreno.yScale = 0.7
        terreno.name = "pavimento"
        terreno.physicsBody = SKPhysicsBody(texture: terreno.texture!, size: terreno.size)
//        terreno.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: UIScreen.main.bounds.size.width , height: 100))
        terreno.physicsBody?.affectedByGravity = false
        terreno.physicsBody?.allowsRotation = false
        terreno.physicsBody?.restitution = 0
        terreno.physicsBody?.isDynamic = false
        terreno.physicsBody?.categoryBitMask = PhysicsCategories.pavimento
        terreno.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
        
        
        
//      pilastri(aka ostacoli)
        
        pilastro1.position = CGPoint(x:700 , y:100)
        pilastro1.xScale = 0.1
        pilastro1.yScale = 0.1
        
        
        backgroundColor = SKColor.white
        
       
//        ADDCHILD
        
        addChild(personaggio)
        addChild(terreno)
        addChild(pilastro1)
        
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
//    FUNZIONE DI SALTO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
            if(cont <= 1){
                personaggio.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
                cont += 1
       }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactA = contact.bodyA.node?.name
        let contactB = contact.bodyB.node?.name
        
        if(contactA == "fantasmino" || contactB == "fantasmino"){
                    
            if(contactA == "pavimento" || contactB == "pavimento"){
                
                    cont = 0
                
//                    personaggio.position = CGPoint(x: personaggio.position.x - 10, y: personaggio.position.y)
//                    personaggio.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
                
            }
        }
    }
    
}
