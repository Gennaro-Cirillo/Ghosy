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
    static let soldi : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

//    VARIABILI UTILI
    
    var cont: Int = 0
    var tempo: Int = 60
    var puntoMoneta: Int = 0
    
    var lastSpawnTimeMoneta:Date?
    var lastSpawnTime2:Date?
    var lastSpawnTime:Date?
    
    
    
//    DICHIARAZIONI SPRITE
    
    
    let personaggio: SKSpriteNode = SKSpriteNode(imageNamed: "walkFrame1")
    let terreno: SKSpriteNode = SKSpriteNode(imageNamed: "base")
    let sky: SKSpriteNode = SKSpriteNode(imageNamed: "skyColor")
    let score: SKSpriteNode = SKSpriteNode(imageNamed: "score")
    let punteggio: SKLabelNode
    let heartFill: SKSpriteNode = SKSpriteNode(imageNamed: "heartFill")
    let heartFill2: SKSpriteNode = SKSpriteNode(imageNamed: "heartFill")
    let heartFill3: SKSpriteNode = SKSpriteNode(imageNamed: "heartFill")
    
    override init(size: CGSize){
        punteggio = SKLabelNode(text: String(tempo))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
//        ANIMAZIONE PERSONAGGIO
        
        personaggio.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "walkFrame1") , SKTexture(imageNamed:"walkFrame2")], timePerFrame: 0.25)))


        
        ChiamataOstacoli()
        backgroundCreation()
        floorCreation()
        
        chiamataMonete()
        
        timer()
        moon()
        starsFlow()
        
//        CARATTERIZZAZIONE DELLE SPRITE
        
//        personaggio(aka fantasmino)
        
        personaggio.position = CGPoint(x: size.width*0.1 , y: size.height * 0.2)
        personaggio.name = "fantasmino"
        personaggio.xScale = size.width * 0.004
        personaggio.yScale = size.height * 0.006
        personaggio.zPosition = 9
        personaggio.physicsBody?.allowsRotation = false
        personaggio.physicsBody?.affectedByGravity = false
        personaggio.physicsBody = SKPhysicsBody(texture: personaggio.texture!, size: personaggio.size)
        personaggio.physicsBody?.restitution = 0
        personaggio.physicsBody?.friction = 999999999999999999
        personaggio.physicsBody?.angularDamping = 999999999999999999
        personaggio.physicsBody?.isResting = false
        personaggio.physicsBody?.linearDamping = 2.5
        personaggio.physicsBody?.categoryBitMask = PhysicsCategories.fantasmino
        personaggio.physicsBody?.contactTestBitMask = PhysicsCategories.pavimento
        
        score.position = CGPoint(x: size.width*0.77 , y: size.height*0.88)
        score.zPosition = 11
        score.xScale = size.width * 0.0003
        score.yScale = size.height * 0.0005
        
        punteggio.position = CGPoint(x: size.width*0.9 , y: size.height*0.85)
        punteggio.zPosition = 11
        punteggio.fontSize = 35
        punteggio.fontName = "Menlo-Bold"
        punteggio.fontColor = .init(hue: 0.76, saturation: 0.12, brightness: 0.69, alpha: 1)
        
        heartFill.position = CGPoint(x: size.width * 0.1  , y: size.height*0.88)
        heartFill.zPosition = 11
        heartFill.xScale = size.width * 0.0001
        heartFill.yScale = size.height * 0.0002
        
        heartFill2.position = CGPoint(x: size.width * 0.16  , y: size.height*0.88)
        heartFill2.zPosition = 11
        heartFill2.xScale = size.width * 0.0001
        heartFill2.yScale = size.height * 0.0002
        
        heartFill3.position = CGPoint(x: size.width * 0.22  , y: size.height*0.88)
        heartFill3.zPosition = 11
        heartFill3.xScale = size.width * 0.0001
        heartFill3.yScale = size.height * 0.0002
        
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
        
        addChild(punteggio)
        addChild(score)
        addChild(personaggio)
        addChild(terreno)
        addChild(sky)
//        addChild(heartFill)
//        addChild(heartFill2)
//        addChild(heartFill3)
        
        self.scene?.physicsWorld.contactDelegate = self
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        moveBackground()
        moveFloor()
//        vittoria()
        punteggio.text = String(((-tempo+60)*10)+puntoMoneta)
        starMove()
        
    }
    
    
    func ChiamataOstacoli(){
        
        var scelta: Int = Int.random(in: 1..<3)
        
        if(scelta==1){
            ostacoloMedio()
        }
        if(scelta==2){
            ostacoloAlto()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+( CGFloat(tempo/15)+1.5), execute: {
            self.ChiamataOstacoli()
        })
        
    }

    func chiamataMonete(){
        moneta()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+10, execute: {
            self.chiamataMonete()
        })
        
    }
    
    
    
//    FUNZIONE DI SALTO
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
            if(cont <= 1){
                personaggio.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
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
        
        if(contactA == "fantasmino" || contactB == "fantasmino"){
            if(contactA == "soldi" || contactB == "soldi"){
                
                enumerateChildNodes(withName: "*"){node, _ in
                    if (node.name == "soldi"){
                        node.removeFromParent()
                        self.puntoMoneta += 100
                    }
                    
                }
                
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
                    pilastro1.xScale = frame.size.width * 0.0025
                    pilastro1.yScale = frame.size.height * 0.005
                    pilastro1.name = "ostacoloAlto"
                    pilastro1.zPosition = 8
                    
                    pilastro1.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "obstacle1") , SKTexture(imageNamed:"obstacle1-1")], timePerFrame: 0.25)))
                    
                    pilastro1.physicsBody = SKPhysicsBody(texture: pilastro1.texture!, size: pilastro1.size)
                    pilastro1.physicsBody?.affectedByGravity = true
                    pilastro1.physicsBody?.allowsRotation = false
                    pilastro1.physicsBody?.restitution = 0
                    pilastro1.physicsBody?.categoryBitMask = PhysicsCategories.ostacoloAlto
                    pilastro1.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
                    
                    pilastro1.run(SKAction.moveTo(x: -80, duration: Double(tempo)*0.06+2), completion: {
                        pilastro1.removeFromParent()
                    })
                    
                    
                    
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
                    pilastro2.xScale = frame.size.width * 0.0025
                    pilastro2.yScale = frame.size.height * 0.005
                    pilastro2.name = "ostacoloBasso"
                    pilastro2.zPosition = 8
                    pilastro2.run(SKAction.moveTo(x: -80, duration: Double(tempo)*0.06+2), completion: {
                        pilastro2.removeFromParent()
                    })
                    pilastro2.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "obstacle2") , SKTexture(imageNamed:"obstacle2-1")], timePerFrame: 0.25)))

                    
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
                    esteticaTerreno.xScale = size.width * 0.002
                    esteticaTerreno.yScale = size.height * 0.0025
                    esteticaTerreno.zPosition = 10
                    esteticaTerreno.position = CGPoint(x: (self.frame.size.width * CGFloat(i) + (self.frame.size.width * CGFloat(i))) * 0.5 , y: 25)
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
            let wait3 = SKAction.wait(forDuration: 1)
            let go = SKAction.run({
//                if self.tempo > 0 {
                    self.tempo -= 1
//                }else{
//    //                TODO
//                }
            })
            
            let actions = SKAction.sequence([wait3, go])
            run(.repeatForever(actions))
        }
    
    func vittoria (){
        if tempo <= 0 {
            self.removeAllChildren()
            
            let schermataVittoria = Win(size: self.size)
            let transition = SKTransition.fade(with: .black, duration: 10)
            self.view?.presentScene(schermataVittoria, transition: transition)
//            let schermataVittoria = Win(size: self.size)
//            self.view?.presentScene(schermataVittoria)
        }
    }
    
    func moon(){
        let moon = SKTexture(imageNamed: "moon")
        
        for i in 0 ... 3 {
            let moon1 = SKSpriteNode(texture: moon)
            moon1.zPosition = 8
            moon1.xScale = size.width * 0.0005
            moon1.yScale = size.width * 0.0005
            moon1.alpha = 0.7
            moon1.anchorPoint = CGPoint.zero
            moon1.position = CGPoint(x: ((self.frame.size.width * self.frame.size.width) * 0.7  * CGFloat(i)) , y: self.frame.size.height * 0.35)
            moon1.name = "background1"
            self.addChild(moon1)
    }
    }
    func starMove(){
        self.enumerateChildNodes(withName: "stars", using: ({
            (node, error) in
            node.position.x -= 2
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func starsFlow(){
        let star = SKTexture(imageNamed: "starsFlow")
        for i in 0 ... 3 {
            let star1 = SKSpriteNode(texture: star)
            star1.zPosition = 9
            star1.xScale = size.width * 0.0009
            star1.yScale = size.width * 0.0009
            star1.alpha = 0.1
            star1.anchorPoint = CGPoint.zero
            star1.position = CGPoint(x: ((self.frame.size.width) * 0.6 * CGFloat(i)) , y: self.frame.size.height * 0.35)
            star1.name = "stars"
            self.addChild(star1)
            
            let twinkle1 = SKAction.fadeIn(withDuration: 5)
            let twinkle2 = SKAction.fadeOut(withDuration: 5)
            let loop = SKAction.sequence([twinkle1, twinkle2])
            let repeatLoop = SKAction.repeatForever(loop)
            star1.run(repeatLoop)
            
    }
    }
    
    func moneta(){
        
        let waitMoneta = SKAction.wait(forDuration: 10, withRange: 1)
        
        let blockMoneta = SKAction.run {[unowned self] in
            //Debug
            let nowMoneta = Date()

            if let lastSpawnTimeMoneta = self.lastSpawnTime {

                let elapsedMoneta = nowMoneta.timeIntervalSince(lastSpawnTimeMoneta)

                print("Sprite spawned after : \(elapsedMoneta)")
            }

        
        
        let coin : SKSpriteNode = SKSpriteNode(imageNamed: "moneta")
        coin.position = CGPoint(x:1000 , y:250)
        coin.xScale = frame.size.width * 0.00065
        coin.yScale = frame.size.height * 0.0015
        coin.name = "soldi"
        coin.zPosition = 8
        coin.run(SKAction.moveTo(x: -80, duration: Double(tempo)*0.06+2))
        
        coin.physicsBody = SKPhysicsBody(texture: coin.texture!, size: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.allowsRotation = true
        coin.physicsBody?.angularVelocity = 5
        coin.physicsBody?.angularDamping = 1.5
        coin.physicsBody?.categoryBitMask = PhysicsCategories.soldi
        coin.physicsBody?.contactTestBitMask = PhysicsCategories.fantasmino
        
            self.addChild(coin)
        }
        
        let sequenceMoneta = SKAction.sequence([blockMoneta, waitMoneta])
        let loopMoneta = SKAction.repeat(sequenceMoneta, count: 1)

        run(loopMoneta, withKey: "cKey")
        
    }
    
}

