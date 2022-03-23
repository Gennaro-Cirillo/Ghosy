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
    static let ostacoloAlto : UInt32 = 0x1 << 2
    static let ostacoloBasso : UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {

//    VARIABILI UTILI
    
    var cont: Int = 0
    
    var lastSpawnTime2:Date?
    var lastSpawnTime:Date?
    
    
//    DICHIARAZIONI SPRITE
    
    
    let personaggio: SKSpriteNode = SKSpriteNode(imageNamed: "walkFrame1")
    let terreno: SKSpriteNode = SKSpriteNode(imageNamed: "base")
    let sky: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
//        ANIMAZIONE PERSONAGGIO
        
        personaggio.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "walkFrame1") , SKTexture(imageNamed:"walkFrame2")], timePerFrame: 0.25)))


        
        ChiamataOstacoli()
        
        backgroundCreation()
        moveBackground()
        
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
        sky.xScale = size.width
        sky.yScale = size.width * 0.002
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

        moveBackground()
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
            }
        }
        
        if(contactA == "fantasmino" || contactB == "fantasmino"){
            if(contactA == "ostacoloAlto" || contactB == "ostacoloAlto"){
                
                self.removeAllChildren()
                
                let schermataSconfitta = GameOver(size: self.size)
                self.view?.presentScene(schermataSconfitta)
            }
        }
        
        if(contactA == "fantasmino" || contactB == "fantasmino"){
            if(contactA == "ostacoloBasso" || contactB == "ostacoloBasso"){
                
                self.removeAllChildren()
                
                let schermataSconfitta = GameOver(size: self.size)
                self.view?.presentScene(schermataSconfitta)
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
                    pilastro1.position = CGPoint(x:1000 , y:90)
                    pilastro1.xScale = 0.05
                    pilastro1.yScale = 0.06
                    pilastro1.name = "ostacoloAlto"
                    
                    pilastro1.physicsBody = SKPhysicsBody(texture: pilastro1.texture!, size: pilastro1.size)
                    pilastro1.physicsBody?.affectedByGravity = true
                    pilastro1.physicsBody?.allowsRotation = false
                    pilastro1.physicsBody?.restitution = 0
                    pilastro1.physicsBody?.categoryBitMask = PhysicsCategories.ostacoloAlto
                    pilastro1.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
                    
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
                    pilastro2.position = CGPoint(x:1000 , y:65)
                    pilastro2.xScale = 0.05
                    pilastro2.yScale = 0.06
                    pilastro2.name = "ostacoloBasso"
                    pilastro2.run(SKAction.moveTo(x: -40, duration: 5))
                    
                    pilastro2.physicsBody = SKPhysicsBody(texture: pilastro2.texture!, size: pilastro2.size)
                    pilastro2.physicsBody?.affectedByGravity = true
                    pilastro2.physicsBody?.allowsRotation = false
                    pilastro2.physicsBody?.restitution = 0
                    pilastro2.physicsBody?.categoryBitMask = PhysicsCategories.ostacoloBasso
                    pilastro2.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
                    
                    self.addChild(pilastro2)
                }

                let sequence = SKAction.sequence([block, wait])
                let loop = SKAction.repeat(sequence, count: 1)

                run(loop, withKey: "aKey")
 
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

