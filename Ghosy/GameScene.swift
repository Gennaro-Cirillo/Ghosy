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
    
    var lastSpawnTime2:Date?
    var lastSpawnTime:Date?
    
    
//    DICHIARAZIONI SPRITE
    
    
    let personaggio: SKSpriteNode = SKSpriteNode(imageNamed: "walkFrame1")
    let terreno: SKSpriteNode = SKSpriteNode(imageNamed: "base")
    let pilastro1: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle1")
    let sky: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
//        ANIMAZIONE PERSONAGGIO
        
        personaggio.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "walkFrame1") , SKTexture(imageNamed:"walkFrame2")], timePerFrame: 0.25)))


        
        ChiamataOstacoli()
        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        
        personaggio.position = CGPoint(x: size.width*0.1 , y: size.height * 0.2)
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
    
        
        
        
       
//        ADDCHILD
        
        addChild(personaggio)
        addChild(terreno)
        addChild(sky)
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

    }
    
    
    func ChiamataOstacoli(){
        
        var scelta: Int = Int.random(in: 1..<3)
        
        if(scelta==1){
            ostacoloMedio()
        }
        if(scelta==2){
            ostacoloAlto()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            self.ChiamataOstacoli()
        })
        
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

    
    
//    FUNZIONE DI COLLISIONE
    
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
    
    
//    GENERATORI DI OSTACOLI
    
    func ostacoloMedio(){
        
        let wait2 = SKAction.wait(forDuration: 2, withRange: 1)

                let block2 = SKAction.run {[unowned self] in
                    //Debug
                    let now2 = Date()

                    if let lastSpawnTime2 = self.lastSpawnTime {

                        let elapsed2 = now2.timeIntervalSince(lastSpawnTime2)

                        print("Sprite spawned after : \(elapsed2)")
                    }
                    self.lastSpawnTime = now2
                    //End Debug

                    let pilastro1: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle1")
                    pilastro1.position = CGPoint(x:1000 , y:100)
                    pilastro1.xScale = 0.07
                    pilastro1.yScale = 0.1
                    pilastro1.run(SKAction.moveTo(x: -40, duration: 5))
                    
                    
                    self.addChild(pilastro1)
                }

                let sequence2 = SKAction.sequence([block2, wait2])
                let loop2 = SKAction.repeat(sequence2, count: 1)

                run(loop2, withKey: "bKey")
        
    }
   
    
    
    
    func ostacoloAlto(){
        
        let wait = SKAction.wait(forDuration: 2, withRange: 1)

                let block = SKAction.run {[unowned self] in
                    //Debug
                    let now = Date()

                    if let lastSpawnTime = self.lastSpawnTime {

                        let elapsed = now.timeIntervalSince(lastSpawnTime)

                        print("Sprite spawned after : \(elapsed)")
                    }
                    self.lastSpawnTime = now
                    //End Debug
                    
                    let pilastro2: SKSpriteNode = SKSpriteNode(imageNamed: "obstacle2")
                    pilastro2.position = CGPoint(x:1000 , y:75)
                    pilastro2.xScale = 0.07
                    pilastro2.yScale = 0.1
                    pilastro2.run(SKAction.moveTo(x: -40, duration: 5))
                    
                    self.addChild(pilastro2)
                }

                let sequence = SKAction.sequence([block, wait])
                let loop = SKAction.repeat(sequence, count: 1)

                run(loop, withKey: "aKey")
 
    }

}
