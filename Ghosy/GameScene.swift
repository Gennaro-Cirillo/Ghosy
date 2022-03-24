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
        floorCreation()
        

        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        
        personaggio.position = CGPoint(x: size.width*0.1 , y: size.height * 0.2)
        personaggio.name = "fantasmino"
        personaggio.xScale = size.width * 0.00015
        personaggio.yScale = size.height * 0.00025
        personaggio.zPosition = 9
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
        
        terreno.position = CGPoint(x: size.width*0.5 ,y: 0)
        terreno.xScale = size.width * 0.01
        terreno.yScale = size.height * 0.0026
        terreno.name = "pavimento"
        terreno.zPosition = 9
        terreno.physicsBody = SKPhysicsBody(texture: terreno.texture!, size: terreno.size)
        terreno.alpha = 0
//        terreno.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: UIScreen.main.bounds.size.width , height: 100))
        terreno.physicsBody?.affectedByGravity = false
        terreno.physicsBody?.allowsRotation = false
        terreno.physicsBody?.restitution = 0
        terreno.physicsBody?.isDynamic = false
        terreno.physicsBody?.categoryBitMask = PhysicsCategories.pavimento
        terreno.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
        
    
        
        sky.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        sky.xScale = 1.8
        sky.yScale = 1.8
        sky.zPosition = 1
        sky.zRotation = 3.14
        
        
        
       
//        ADDCHILD
        
        addChild(personaggio)
        addChild(terreno)
        addChild(sky)
        
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        moveBackground()
        moveFloor()

    }
    
    
    func ChiamataOstacoli(){
        
        var scelta: Int = Int.random(in: 1..<3)
        
        if(scelta==1){
            ostacoloMedio()
        }
        if(scelta==2){
            ostacoloAlto()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.ChiamataOstacoli()
        })
        
    }
    
    
    
//    FUNZIONE DI SALTO
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
            if(cont <= 1){
                personaggio.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
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
                let transition = SKTransition.fade(with: .black, duration: 10)
                self.view?.presentScene(schermataSconfitta, transition: transition)
            }
        }
        
    }
    
    
    
//    GENERATORI DI OSTACOLI
    
    func ostacoloAlto(){
        
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
                    pilastro1.position = CGPoint(x:1000 , y:80)
                    pilastro1.xScale = frame.size.width * 0.0065
                    pilastro1.yScale = frame.size.height * 0.01
                    pilastro1.name = "ostacoloAlto"
                    pilastro1.zPosition = 8
                    
                    pilastro1.physicsBody = SKPhysicsBody(texture: pilastro1.texture!, size: pilastro1.size)
                    pilastro1.physicsBody?.affectedByGravity = true
                    pilastro1.physicsBody?.allowsRotation = false
                    pilastro1.physicsBody?.restitution = 0
                    pilastro1.physicsBody?.categoryBitMask = PhysicsCategories.ostacoloAlto
                    pilastro1.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
                    
                    pilastro1.run(SKAction.moveTo(x: -80, duration: 5))
                    
                    
                    self.addChild(pilastro1)
                }

                let sequence2 = SKAction.sequence([block2, wait2])
                let loop2 = SKAction.repeat(sequence2, count: 1)

                run(loop2, withKey: "bKey")
        
    }
   
    
    
    
    func ostacoloMedio(){
        
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
                    pilastro2.xScale = frame.size.width * 0.0065
                    pilastro2.yScale = frame.size.height * 0.009
                    pilastro2.name = "ostacoloBasso"
                    pilastro2.zPosition = 8
                    pilastro2.run(SKAction.moveTo(x: -80, duration: 5))
                    
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
    
    
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "background1", using: ({
            (node, error) in
            node.position.x -= 1
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 2.8
            }
        }))
    }
    
    func backgroundCreation(){
            let backgroundTexture1 = SKTexture(imageNamed: "background1")
           
                    
                for i in 0 ... 3 {
                    let background1_1 = SKSpriteNode(texture: backgroundTexture1)
                    background1_1.zPosition = 8
                    background1_1.xScale = size.width * 0.00135
                    background1_1.yScale = size.width * 0.00135
                    background1_1.alpha = 0.7
                    background1_1.anchorPoint = CGPoint.zero
                    background1_1.position = CGPoint(x: (self.frame.size.width * 0.69  * CGFloat(i)) , y: self.frame.size.height * 0.23)
                    background1_1.name = "background1"
                    self.addChild(background1_1)
                }
        }

    func floorCreation(){
            let terrenoTexture = SKTexture(imageNamed: "base2")
           
                    
                for i in 0 ... 3 {
                    let esteticaTerreno = SKSpriteNode(texture: terrenoTexture)
                    esteticaTerreno.xScale = size.width * 0.003
                    esteticaTerreno.yScale = size.height * 0.004
                    esteticaTerreno.zPosition = 10
                    esteticaTerreno.position = CGPoint(x: (self.frame.size.width * CGFloat(i) + (self.frame.size.width * CGFloat(i))) * 0.5 , y: 30)
                    esteticaTerreno.name = "estetica"
                    self.addChild(esteticaTerreno)
                }
        }
    
    func moveFloor(){
        self.enumerateChildNodes(withName: "estetica", using: ({
            (node, error) in
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 2.4
            }
        }))
    }
    
    func timer(){
        
    }

}

