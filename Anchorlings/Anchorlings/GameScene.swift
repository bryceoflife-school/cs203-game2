//
//  GameScene.swift
//  Anchorlings
//
//  Created by Bryce Daniel on 11/15/14.
//  Copyright (c) 2014 Bryce Daniel. All rights reserved.
//

import SpriteKit
import UIKit
import Foundation

// Object Variables
var foreground: SKSpriteNode!
var backgroundMountains: SKSpriteNode!
var smallCloud: SKSpriteNode!
var bigCloud:SKSpriteNode!
var slowTimeIndicator: SKSpriteNode!
var growIndicator: SKSpriteNode!
var parachuteIndicator: SKSpriteNode!
var anchorNormal: SKSpriteNode!
var anchorSet: SKNode!

// Game State Variables
var gravityValue: CGFloat = 1.5

// Random Variable
var columnMultiplier: CGFloat!

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.gravity = CGVectorMake(0.0, -gravityValue)
        
        setupBackground()
        setupForeround()
        setupBackgroundMountains()
        setupSmallCloud()
        setupBigCloud()
        setupSlowTimeIndicator()
        self.childNodeWithName("slowTimeIndicator")?.alpha = 0.3
        setupGrowIndicator()
        self.childNodeWithName("growIndicator")?.alpha = 0.3
        setupParachuteIndicator()
        self.childNodeWithName("parachuteIndicator")?.alpha = 0.3
        
        anchorSet = SKNode()
        self.addChild(anchorSet)
        
        spawnAnchorNormals()
        
        
    }
    
    // Setup the World
    // Add Background
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "backgroundSkyGradient")
        background.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        background.size = CGSizeMake(self.frame.width/2, self.frame.height)
        background.zPosition = -100
        self.addChild(background)
    }
    
    //Add Ground layer
    func setupForeround() {
        foreground = SKSpriteNode(imageNamed: "foregroundHills")
        foreground.position = CGPointMake(self.frame.width / 2, 75)
        foreground.size = CGSizeMake(self.frame.width/2.3, foreground.frame.height/1.8)
        foreground.zPosition = -9
        foreground.physicsBody = SKPhysicsBody(rectangleOfSize: foreground.size)
        foreground.physicsBody?.dynamic = false
        
//        foreground.physicsBody?.categoryBitMask = worldCategory
//        foreground.physicsBody?.contactTestBitMask = blockCategory
//        foreground.physicsBody?.collisionBitMask = blockCategory
        
        self.addChild(foreground)
    }
    
    //Add background Mountains layer
    func setupBackgroundMountains() {
        backgroundMountains = SKSpriteNode(imageNamed: "backgroundMountains")
        backgroundMountains.position = CGPointMake(self.frame.width / 2, 34)
        backgroundMountains.size = CGSizeMake(self.frame.width/2.3, backgroundMountains.frame.height/1.6)
        backgroundMountains.zPosition = -20
        backgroundMountains.physicsBody = SKPhysicsBody(rectangleOfSize: backgroundMountains.size)
        backgroundMountains.physicsBody?.dynamic = false
        
        //        backgroundMountains?.categoryBitMask = worldCategory
        //        backgroundMountains?.contactTestBitMask = blockCategory
        //        backgroundMountains?.collisionBitMask = blockCategory
        
        self.addChild(backgroundMountains)
    }
    
    func setupSmallCloud(){
        smallCloud = SKSpriteNode(imageNamed: "cloudSmall")
        smallCloud.anchorPoint = CGPointMake(0, 0)
        smallCloud.position = CGPointMake(self.frame.width/3.2, self.frame.height / 2.8)
        smallCloud.size = CGSizeMake(smallCloud.frame.width/1.5, smallCloud.frame.height/1.5)
        smallCloud.zPosition = -15
        smallCloud.physicsBody?.dynamic = false
        self.addChild(smallCloud)
    }
    
    func setupBigCloud(){
        bigCloud = SKSpriteNode(imageNamed: "cloudBig")
        bigCloud.anchorPoint = CGPointMake(0, 0)
        bigCloud.position = CGPointMake(self.frame.width/1.95, self.frame.height / 3.5)
        bigCloud.size = CGSizeMake(bigCloud.frame.width/1.6, bigCloud.frame.height/1.6)
        bigCloud.zPosition = -16
        bigCloud.physicsBody?.dynamic = false
        self.addChild(bigCloud)
    }
    
    func setupSlowTimeIndicator(){
        slowTimeIndicator = SKSpriteNode(imageNamed: "anchorPowerupTime")
        slowTimeIndicator.anchorPoint = CGPointMake(0, 0)
        slowTimeIndicator.position = CGPointMake(self.frame.width/3.3, self.frame.height / 5)
        slowTimeIndicator.size = CGSizeMake(slowTimeIndicator.frame.width / 2, slowTimeIndicator.frame.height / 2 )
        slowTimeIndicator.zPosition = -3
        slowTimeIndicator.name = "slowTimeIndicator"
        self.addChild(slowTimeIndicator)
    }
    
    func setupGrowIndicator(){
        growIndicator = SKSpriteNode(imageNamed: "anchorPowerupGrow")
        growIndicator.anchorPoint = CGPointMake(0, 0)
        growIndicator.position = CGPointMake(self.frame.width/3.3, self.frame.height / 8)
        growIndicator.size = CGSizeMake(growIndicator.frame.width / 2, growIndicator.frame.height / 2 )
        growIndicator.zPosition = -5
        growIndicator.name = "growIndicator"
        self.addChild(growIndicator)
    }
    
    func setupParachuteIndicator(){
        parachuteIndicator = SKSpriteNode(imageNamed: "anchorPowerupParachute")
        parachuteIndicator.anchorPoint = CGPointMake(0, 0)
        parachuteIndicator.position = CGPointMake(self.frame.width/3.3, self.frame.height / 20)
        parachuteIndicator.size = CGSizeMake(parachuteIndicator.frame.width / 2, parachuteIndicator.frame.height / 2 )
        parachuteIndicator.zPosition = -5
        parachuteIndicator.name = "parachuteIndicator"
        self.addChild(parachuteIndicator)
    }

    func randomY(height: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) % CGFloat(height / 1)
    }
    
    func setupAnchor(){
        anchorNormal = SKSpriteNode(imageNamed: "anchorNormal")
        
        do {
            columnMultiplier = (CGFloat(arc4random_uniform(100))) / 100
        } while(columnMultiplier <= 0.3 || columnMultiplier >= 0.7)
        anchorNormal.size = CGSizeMake(columnMultiplier * anchorNormal.frame.width / 2, columnMultiplier *  anchorNormal.frame.height / 2)
        
        anchorNormal.position = CGPointMake((columnMultiplier * self.frame.width), (randomY(self.frame.size.height)))
        anchorNormal.physicsBody = SKPhysicsBody(circleOfRadius: anchorNormal.frame.height/2)
        anchorNormal.physicsBody?.dynamic = false
        
        anchorNormal.name = "anchorNormal"
        anchorSet.addChild(anchorNormal)
    }
    
    func spawnAnchorNormals(){
        let spawn = SKAction.runBlock { () -> Void in
            self.setupAnchor()
        }
        let delay = SKAction.waitForDuration(2.0)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)


    }

    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
