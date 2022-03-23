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
    let pilastro1: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle1")
    let sky: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
    
    
    override func didMove(to view: SKView) {
        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        backgroundCreation()
        groundCreation()
        
        personaggio.position = CGPoint(x:400 , y:90)
        personaggio.name = "fantasmino"
        personaggio.xScale = size.width * 0.0002
        personaggio.yScale = size.width * 0.0002
        personaggio.physicsBody = SKPhysicsBody(texture: personaggio.texture!, size: personaggio.size)
        personaggio.physicsBody?.restitution = 0
        personaggio.physicsBody?.categoryBitMask = PhysicsCategories.fantasmino
        personaggio.physicsBody?.contactTestBitMask = PhysicsCategories.pavimento
        
        sky.position = CGPoint(x: self.frame.size.width * 0.5 , y: self.frame.size.height * 0.5)
        sky.zPosition = -2
        sky.xScale = size.width
        sky.yScale = size.width * 0.002
        sky.alpha = 1
//      terreno(aka pavimento)
        

        
        
        
//      pilastri(aka ostacoli)
        
        pilastro1.position = CGPoint(x:700 , y:100)
        pilastro1.xScale = 0.1
        pilastro1.yScale = 0.1
        
        
        backgroundColor = SKColor.white
        
       
//        ADDCHILD
        
        addChild(personaggio)
        addChild(pilastro1)
        addChild(sky)
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBackground()
        moveGround()

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
    func groundCreation(){
        for i in 0...3{
            let colliderTerreno = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            let terreno: SKSpriteNode = SKSpriteNode(imageNamed: "base")
            colliderTerreno.position = CGPoint(x: (self.frame.size.width * CGFloat(i)) , y: self.frame.size.height * 0.1)
            colliderTerreno.fillColor = .red
            colliderTerreno.xScale = size.width * 0.005
            colliderTerreno.yScale = size.width * 0.00025
            colliderTerreno.alpha = 0.001
            colliderTerreno.physicsBody = SKPhysicsBody(texture: terreno.texture!, size: terreno.size)
            colliderTerreno.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: UIScreen.main.bounds.size.width , height: 100))
            colliderTerreno.physicsBody?.affectedByGravity = false
            colliderTerreno.physicsBody?.allowsRotation = false
            colliderTerreno.physicsBody?.restitution = 0
            colliderTerreno.physicsBody?.isDynamic = false
            colliderTerreno.physicsBody?.categoryBitMask = PhysicsCategories.pavimento
            colliderTerreno.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
            colliderTerreno.zPosition = 0
            terreno.name = "pavimento"
            terreno.position = CGPoint(x: (self.frame.size.width * CGFloat(i)) , y: self.frame.size.height * 0.1)
            terreno.xScale = size.width * 0.00195
            terreno.yScale = size.width * 0.0017
            terreno.zPosition = 1
            self.addChild(terreno)
            self.addChild(colliderTerreno)
        }
    }
    func moveGround(){
        self.enumerateChildNodes(withName: "pavimento", using: ({
            (node, error) in
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func backgroundCreation(){
        let backgroundTexture1 = SKTexture(imageNamed: "background1")
       
                
            for i in 0 ... 3 {
                let background1_1 = SKSpriteNode(texture: backgroundTexture1)
                background1_1.zPosition = -1
                background1_1.xScale = size.width * 0.00135
                background1_1.yScale = size.width * 0.00135
                background1_1.alpha = 0.7
                background1_1.anchorPoint = CGPoint.zero
                background1_1.position = CGPoint(x: (self.frame.size.width * 0.69  * CGFloat(i)) , y: self.frame.size.height * 0.23)
                background1_1.name = "background1"
                self.addChild(background1_1)
            }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "background1", using: ({
            (node, error) in
            node.position.x -= 1
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 2.8
            }
        }))
    }
}
