//
//  GameScene.swift
//  Anchorlings
//
//  Created by Bryce Daniel on 11/15/14.
//  Copyright (c) 2014 Bryce Daniel. All rights reserved.
//

/*
Todo:
Random anchor generation upon player advancement.
Spring joint for character arms
Snap to anchor for character arms
Draggable character
anchors move ranodmly within vacinity
parachute activates when player's y begins decreasing /// Find meaning for parachute or make new powerup
visual state change for slow motion
points increase with player height / anchor 
replay screen


*/

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
var anchorInitial: SKSpriteNode!
var anchorling: SKSpriteNode!
var anchorlingArmL: SKSpriteNode!
var anchorlingArmR: SKSpriteNode!
var anchorSet: SKNode!

// Textures
var anchorlingTexture: SKTexture!
var anchorlingArmLTexture: SKTexture!
var anchorlingArmRTexture: SKTexture!
var backgroundMountainsTexture: SKTexture!
var foregroundTexture: SKTexture!

// Game State Variables
var gravityValue: CGFloat = 1.5

// Random Variable
var columnMultiplier: CGFloat!
var rowMultiplier: CGFloat!
var sizeMultiplier: CGFloat!


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
        
        setupInitialAnchor()
        setupAnchorling()
        
//        spawnAnchorNormals()
        
        
        
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
        foregroundTexture = SKTexture(imageNamed: "foregroundHills")
        foreground.physicsBody = SKPhysicsBody(texture: foregroundTexture, size: foreground.size)
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
//        backgroundMountainsTexture = SKTexture(imageNamed: "backgroundMountains")
//        backgroundMountains.physicsBody = SKPhysicsBody(texture: backgroundMountainsTexture, size: backgroundMountains.size)
//        backgroundMountains.physicsBody?.dynamic = false
        
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
    
    func setupAnchorling() {
        anchorling = SKSpriteNode(imageNamed: "anchorlingBody")
        anchorlingArmL = SKSpriteNode(imageNamed: "anchorlingArmL")
        anchorlingArmR = SKSpriteNode(imageNamed: "anchorlingArmR")
        
        anchorling.position = CGPointMake((self.frame.width / 2), (self.frame.height / 2))
        anchorling.size = CGSizeMake(anchorling.frame.width / 2, anchorling.frame.height / 2)
        
        anchorlingArmL.position = CGPointMake(((self.frame.width / 2) + 10), (self.frame.height / 2))
        anchorlingArmL.size = CGSizeMake(anchorlingArmL.frame.width / 2, anchorlingArmL.frame.height / 2)
        
        anchorlingArmR.position = CGPointMake(((self.frame.width / 2) + 10), (self.frame.height / 2))
        anchorlingArmR.size = CGSizeMake(anchorlingArmR.frame.width / 2, anchorlingArmR.frame.height / 2)
        
        // Create textures
        anchorlingTexture = SKTexture(imageNamed: "anchorlingBody")
        anchorlingArmLTexture = SKTexture(imageNamed: "anchorlingArmL")
        anchorlingArmRTexture = SKTexture(imageNamed: "anchorlingArmR")
        
        // Create physics bodies
        anchorling.physicsBody = SKPhysicsBody(texture: anchorlingTexture, size: anchorling.size)
        
        anchorlingArmL.physicsBody = SKPhysicsBody(texture: anchorlingArmLTexture, size: anchorlingArmL.size)
    
        anchorlingArmR.physicsBody = SKPhysicsBody(texture: anchorlingArmRTexture, size: anchorlingArmR.size)
       
        anchorlingArmR.physicsBody?.dynamic = false
        
        // Add objects to world
        self.addChild(anchorling)
        self.addChild(anchorlingArmL)
        self.addChild(anchorlingArmR)
        
        // Create Joint
        var jointArmL = SKPhysicsJointPin.jointWithBodyA(anchorling.physicsBody, bodyB: anchorlingArmL.physicsBody, anchor: CGPoint(x: CGRectGetMinX(anchorling.frame), y: CGRectGetMidY(anchorling.frame)))
        var jointArmR = SKPhysicsJointPin.jointWithBodyA(anchorling.physicsBody, bodyB: anchorlingArmR.physicsBody, anchor: CGPoint(x: CGRectGetMaxX(anchorling.frame), y: CGRectGetMidY(anchorling.frame)))
//        var jointArmL = SKPhysicsJointLimit.jointWithBodyA(anchorling.physicsBody, bodyB: anchorlingArmL.physicsBody, anchorA: CGPoint(x: CGRectGetMaxX(anchorling.frame), y: CGRectGetMidY(anchorling.frame)), anchorB: CGPointZero)
        self.physicsWorld.addJoint(jointArmL)
        self.physicsWorld.addJoint(jointArmR)
    }
    
    func attachLeftArm() {
        
    }
    
    func setupInitialAnchor(){
        anchorInitial = SKSpriteNode(imageNamed: "anchorNormal")
        anchorInitial.size = CGSizeMake(anchorInitial.frame.width / 2, anchorInitial.frame.height / 2)
        
        anchorInitial.position = CGPointMake((self.frame.width / 2),( self.frame.size.height / 5))
        anchorInitial.physicsBody = SKPhysicsBody(circleOfRadius: anchorInitial.frame.height/2)
        anchorInitial.physicsBody?.dynamic = false
        
        anchorInitial.name = "anchorInitial"
        self.addChild(anchorInitial)
    }
    
    func setupAnchor(){
        anchorNormal = SKSpriteNode(imageNamed: "anchorNormal")
        
        do {
            columnMultiplier = (CGFloat(arc4random_uniform(100))) / 100
        } while(columnMultiplier <= 0.3 || columnMultiplier >= 0.7)
        
        do {
            rowMultiplier = (CGFloat(arc4random_uniform(100))) / 100
        } while(rowMultiplier <= 0.5 || rowMultiplier >= 0.95)
        
        do {
            sizeMultiplier = (CGFloat(arc4random_uniform(100))) / 100
        } while(sizeMultiplier <= 0.5 || sizeMultiplier >= 1.0)
        
        anchorNormal.size = CGSizeMake(sizeMultiplier * anchorNormal.frame.width / 2, sizeMultiplier *  anchorNormal.frame.height / 2)
        
        anchorNormal.position = CGPointMake((columnMultiplier * self.frame.width), (rowMultiplier * self.frame.size.height))
        anchorNormal.physicsBody = SKPhysicsBody(circleOfRadius: anchorNormal.frame.height/2)
        anchorNormal.physicsBody?.dynamic = false
        
        anchorNormal.name = "anchorNormal"
        anchorSet.addChild(anchorNormal)
        anchorNormal.alpha = 0
        let scale0 = SKAction.scaleTo(0, duration: 0)
        anchorNormal.runAction(scale0)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.2)
        let scaleIn = SKAction.scaleTo(1.0, duration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0)
        let fadeAndScale = SKAction.group([fadeIn,scaleIn])
        anchorNormal.runAction(fadeAndScale)
        

    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
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
            let location = touch.locationInNode(self) as CGPoint
            setupAnchor()
//            let time = NSTimeInterval(abs(location.x - anchorNormal.position.x) * 0.0009)
//
//            if (location.x != anchorNormal.position.x) {
//                anchorNormal.runAction(SKAction.moveToX(location.x, duration: time))
//            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
