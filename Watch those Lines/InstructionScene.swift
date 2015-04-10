//
//  InstructionScene.swift
//  Watch those Lines
//
//  Created by RaghuKV on 3/31/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation
import Spritekit

class InstructionScene : SKScene {
    /* Objects involved in displaying the instructions */
    var instructionText = SKSpriteNode();
    var finger = SKSpriteNode();
    var controlCircle = SKSpriteNode();
    var gameUtils = GameUtils();
    
    /*
    PHYSICS BODY CATEGORIES
    A category is given to a node to detect collision
    */
    var mainCategory : UInt32 = 0x1 << 0
    var dropCategory: UInt32 = 0x1 << 1
    var boundaryCategory: UInt32 = 0x1 << 2
    var collectibleCategory: UInt32 = 0x1 << 3
    var waterCategory: UInt32 = 0x1 << 4
    
    var dataMan = DataManager()
    
    var fromInstructionsButton : Bool = false
    
    
    var playButton : SKLabelNode = SKLabelNode()
    
    var initialTouchDone = false;
    
    var yValues : Dictionary<Int, CGFloat> = Dictionary<Int, CGFloat>();
    
    
    override func didMoveToView(view: SKView) {
        
        yValues = PositionUtils.getYvalues(self.frame)
//        for (var i = 1; i <= 16; i++){
//            
//                        var line = gameUtils.drawHorizontalHintLine(self.frame.width)
//                        line.alpha = 0.3
//                        line.position = CGPointMake(self.frame.midX, yValues[i]!)
//                        self.addChild(line)
//            
//        }
        
        playInstructions()
    }
    
    
    func playInstructions() -> Void {
        self.instructionText = gameUtils.drawInstructions()
        self.instructionText.name = "instructions"
        self.instructionText.position = CGPointMake(self.frame.midX, yValues[12]!)
        self.addChild(instructionText)
        var fadeIn = SKAction.fadeInWithDuration(0.7)
        instructionText.runAction(fadeIn)
        
        setUpControlObject()
        
        self.finger = gameUtils.drawFinger()
        self.finger.name = "finger"
        self.finger.position = CGPointMake(CGRectGetMidX(self.scene!.frame), yValues[4]!)
        self.addChild(finger)
        
        var left = SKAction.moveByX(-100, y: 0, duration: 0.5)
        var right = SKAction.moveByX(+200, y: 0, duration: 1)
        self.finger.runAction(fadeIn)
        self.finger.runAction(SKAction.repeatActionForever(SKAction.sequence([left,right,left])))
        
    }
    
    func setUpControlObject() -> Void {
        
        self.controlCircle = gameUtils.drawControlObject()
        controlCircle.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMidY(self.scene!.frame
            ))
        self.addChild(controlCircle)
        
        gameUtils.fadeIn(controlCircle, duration: 0.7)
        controlCircle.physicsBody?.allowsRotation = false
        controlCircle.physicsBody?.dynamic = true
        controlCircle.physicsBody?.affectedByGravity = false
        controlCircle.physicsBody?.categoryBitMask = mainCategory
        controlCircle.physicsBody?.contactTestBitMask = dropCategory | waterCategory
        controlCircle.physicsBody?.collisionBitMask = dropCategory | waterCategory
        
        var xRange = SKRange(lowerLimit: self.frame.minX, upperLimit: self.frame.maxX)
        var yRange = SKRange(lowerLimit: self.frame.minY, upperLimit: self.frame.maxY)
        var areaConstraint = SKConstraint.positionX(xRange, y: yRange)
        controlCircle.constraints = [areaConstraint];
        
        controlCircle.name = "controlObj"
        
    }
    
    func showAvoidInstruction() -> Void {
        var avoid = SKSpriteNode(imageNamed: "avoidInstruction")
        avoid.name = "avoid"
        avoid.position = CGPointMake(CGRectGetMidX(self.scene!.frame), yValues[12]!)
        avoid.alpha = 0.0
        self.addChild(avoid)
        var fadeIn = SKAction.fadeInWithDuration(0.5)
        var wait = SKAction.waitForDuration(2)
        var fadeOut = SKAction.runBlock({
            self.gameUtils.fadeOutAndKillWithDuration(avoid, duration: 0.2)
        })
        
        var collectThese = SKSpriteNode(imageNamed: "collectThese")
        collectThese.name = "collect"
        collectThese.position = CGPointMake(CGRectGetMidX(self.scene!.frame), yValues[12]!)
        collectThese.alpha = 0.0
        self.addChild(collectThese)
        var fadeOutCollect = SKAction.runBlock({
            self.gameUtils.fadeOutAndKillWithDuration(collectThese, duration: 0.2)
        })
        
        var moveToCenter = SKAction.moveTo(CGPointMake(self.frame.midX, self.frame.midY), duration: 1.0)
        avoid.runAction(SKAction.sequence([fadeIn, wait, fadeOut]), completion: { () -> Void in
            collectThese.runAction(SKAction.sequence([fadeIn, wait, fadeOutCollect]), completion: { () -> Void in
                self.controlCircle.runAction(moveToCenter, completion: { () -> Void in
                    self.dataMan.userPrefs.userTookInstructions = true
                    self.dataMan.saveUserPrefs()
                    
                    
                    if(self.fromInstructionsButton){
                        self.playButton = GameUtils.getLabelNodeWithText("play", name: "playButton");
                        self.playButton.name = "playButton"
                        self.addChild(self.playButton)
                        self.playButton.position = CGPointMake(self.frame.midX, self.yValues[4]!)
                        self.playButton.runAction(fadeIn)
                    }
                    else
                    {
                        var skView = self.view as SKView!
                        var scene = GameScene()
                        scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
                        scene.size = skView.bounds.size
                        scene.scaleMode = SKSceneScaleMode.AspectFill
                        self.scene!.view!.presentScene(scene)
                    }
                })
            })
        })
    }
    
    func removeInstructions() -> Void {
        gameUtils.fadeOutAndKillWithDuration(self.instructionText, duration: 0.2)
        gameUtils.fadeOutAndKillWithDuration(self.finger, duration: 0.2)
        showAvoidInstruction()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        
        if(node.name == "playButton"){
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            var scene : SKScene!
            scene = GameScene()
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }

    }


    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var currentTouch : CGPoint = touch.locationInNode(self)
        var previousTouch : CGPoint = touch.previousLocationInNode(self)
        var circlePosition = controlCircle.position
        var difference = CGPointMake(currentTouch.x - previousTouch.x, currentTouch.y - previousTouch.y)
        var newX = circlePosition.x + difference.x;
        var newY = circlePosition.y + difference.y;
        var newPos = CGPointMake(newX, newY);
        var checkPos = CGPointMake(newX - controlCircle.frame.width/2, newY)
        var checkPosTwo = CGPointMake(newX + controlCircle.frame.width/2, newY)
        
        if(self.frame.contains(checkPos) && self.frame.contains(checkPosTwo)){

            controlCircle.position = newPos
        }else{
            controlCircle.position.y = newPos.y
        }
        
        if(!initialTouchDone){
            initialTouchDone = true
            gameUtils.fadeOutAndKill(self.finger)
            removeInstructions()
        }
    }


}
