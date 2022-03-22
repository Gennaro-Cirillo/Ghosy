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
    let sky: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
    
    
    override func didMove(to view: SKView) {
        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        backgroundCreation()
        
        personaggio.position = CGPoint(x:400 , y:90)
        personaggio.name = "fantasmino"
        personaggio.xScale = 0.1
        personaggio.yScale = 0.1
        personaggio.physicsBody = SKPhysicsBody(texture: personaggio.texture!, size: personaggio.size)
        personaggio.physicsBody?.restitution = 0
        personaggio.physicsBody?.categoryBitMask = PhysicsCategories.fantasmino
        personaggio.physicsBody?.contactTestBitMask = PhysicsCategories.pavimento
        
        sky.position = CGPoint(x: self.frame.size.width * 0.5 , y: self.frame.size.height * 0.5)
        sky.zPosition = -2
        sky.xScale = frame.width * 0.1
        sky.yScale =  0.5
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
        addChild(sky)
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBackground()

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
    
    
    func backgroundCreation(){
        let backgroundTexture1 = SKTexture(imageNamed: "background1")
        let backgroundTexture2 = SKTexture(imageNamed: "background2")
                
            for i in 0 ... 3 {
                let background1_1 = SKSpriteNode(texture: backgroundTexture1)
                background1_1.zPosition = -1
                background1_1.xScale = 1.2
                background1_1.yScale = 1.2
                background1_1.anchorPoint = CGPoint.zero
                background1_1.position = CGPoint(x: (self.frame.size.width * 0.69  * CGFloat(i)) , y: self.frame.size.height * 0.1)
                background1_1.name = "background1"
                self.addChild(background1_1)

                for i in 4...4{
                    let background1_2 = SKSpriteNode(texture: backgroundTexture2)
                    background1_2.zPosition = -1
                    background1_2.xScale = 1.2
                    background1_2.yScale = 1.2
                    background1_2.anchorPoint = CGPoint.zero
                    background1_2.name = "background2"
                    background1_2.position = CGPoint(x: ((self.frame.size.width) * 0.69  * CGFloat(i)), y: self.frame.size.height * 0.1 )
                    self.addChild(background1_2)
                }
            }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "background1", using: ({
            (node, error) in
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3.4
            }
        }))
        
        self.enumerateChildNodes(withName: "background2", using: ({
            (node, error) in
            node.position.x -= 2

            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 5
            }
        }))

    }
}
