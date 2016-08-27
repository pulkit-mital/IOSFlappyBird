//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Pulkit Mital on 24/08/16.
//  Copyright (c) 2016 Pulkit Mital. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var scoreLable = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    let gapGroup:UInt32 = 0 << 3
    
    
    var gameOver = 0
    var movingObjects = SKNode()
    var labelHolder = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Setting up the delegate 
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
       
        
        //Adding background to scene
        addBackgroundToScene()
        
        //Adding pipes to the scene
        let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.makePipes), userInfo: nil, repeats: true)
        
     
        
        //Adding Score Label
        addScoreLabel()
        
        //Adding flappy bird to the scene
        addingFlappyBird()
        
        //interacting with ground when bird falls down
        addingGround()
        self.addChild(movingObjects)
        self.addChild(labelHolder)
        
 
    }
    
    
    //Adding ground, Game gets over when bird touches it 
    
    func addingGround(){
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        
        self.addChild(ground)
    }
    
    //Adding bird to the scene
    
    func addingFlappyBird(){
        let birdTexture = SKTexture(imageNamed: "img/flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "img/flappy2.png")
    
        let animation = SKAction.animateWithTextures([birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
    
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
    
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody!.dynamic = true
        bird.physicsBody!.allowsRotation = false
        bird.physicsBody!.categoryBitMask = birdGroup
        bird.physicsBody!.collisionBitMask = gapGroup
        bird.physicsBody!.contactTestBitMask = objectGroup
        bird.zPosition = 10
    
        self.addChild(bird)
    }
    
    // Adding score to the scene 
    
    func addScoreLabel(){
        
        scoreLable.fontName = "Helvetica"
        scoreLable.fontSize = 50
        scoreLable.text = "0"
        scoreLable.zPosition = 10
        scoreLable.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLable)

    }
    
    //adding background of the scene
    
    func addBackgroundToScene() {
        
        let bgTexture = SKTexture(imageNamed: "img/bg.png")
        let moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatActionForever(SKAction.sequence([moveBg,replaceBg]))
        
        for var i:CGFloat = 0; i<3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBgForever)
            movingObjects.addChild(bg)
        }
    }
    
    //Making pipes obstacles
    
    func makePipes(){
        //Adding pipes for collision objects
        if(gameOver == 0){
            
            let gapHeight = bird.size.height * 4
            let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
            let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
            let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        
            let removePipes = SKAction.removeFromParent()
            let moveandRemovePipes = SKAction.repeatActionForever(SKAction.sequence([movePipes,removePipes]))
        
            let pipe1Texture = SKTexture(imageNamed: "img/pipe1.png")
            let pipe1 = SKSpriteNode(texture: pipe1Texture)
            pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
            pipe1.runAction(moveandRemovePipes)
            pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
            pipe1.physicsBody!.dynamic = false
            pipe1.physicsBody!.categoryBitMask = objectGroup

            movingObjects.addChild(pipe1)
        
            
            let pipe2Texture = SKTexture(imageNamed: "img/pipe2.png")
            let pipe2 = SKSpriteNode(texture: pipe2Texture)
            pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight/2 + pipeOffset)
            pipe2.runAction(moveandRemovePipes)
            pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
            pipe2.physicsBody!.dynamic = false
            pipe2.physicsBody!.categoryBitMask = objectGroup

            movingObjects.addChild(pipe2)
            
            let gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = gapGroup
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width,gapHeight))
            gap.physicsBody?.categoryBitMask = gapGroup
            gap.runAction(moveandRemovePipes)
            gap.physicsBody?.contactTestBitMask = birdGroup
            movingObjects.addChild(gap)
        }

    }
    
    // Working when one object is in contact with another object
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            
            if gameOver == 0 {
             score += 1
             scoreLable.text = "\(score)"
            }
            
        } else {
            
            if gameOver == 0{
                gameOver = 1
                movingObjects.speed = 0
            
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to Play Again"
                gameOverLabel.zPosition = 10
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(gameOverLabel)
            }
            
            
        }
        
        
    }
    
    //This function is called, when user interacts with the screen through touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameOver == 0 {
          bird.physicsBody?.velocity = CGVectorMake(0, 0)
          bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }else{
            scoreLable.text = "0"
            score = 0
            movingObjects.removeAllChildren()
            addBackgroundToScene()
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            labelHolder.removeAllChildren()
            gameOver = 0
            movingObjects.speed = 1

        }
        
        

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
