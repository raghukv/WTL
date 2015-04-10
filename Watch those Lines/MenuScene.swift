//
//  MenuScene.swift
//  Watch those Lines
//
//  Created by RaghuKV on 3/28/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation
import Spritekit

class MenuScene : SKScene {
    var title : SKSpriteNode = SKSpriteNode(imageNamed: "launchImage.png")
    var center : CGPoint!
    var gameUtils = GameUtils()
    var fadeIn : SKAction = SKAction.fadeInWithDuration(0.1)
    var scoreManager = DataManager()
    var scores:Array<BestScore> = [];
    
    var instructions : SKLabelNode = SKLabelNode();
    var playButton : SKLabelNode = SKLabelNode()
    var playNew : SKLabelNode = SKLabelNode()
    var scoreLabel : SKLabelNode = SKLabelNode(text: "best score empty");
    var previousHighest : Double = 0.0
    var highScore : Double = 0.0
    var checkPoint : Int = 0
    
    var reverse : SKLabelNode = SKLabelNode()
    
    var yValues : Dictionary<Int, CGFloat> = Dictionary<Int, CGFloat>();
    
    var count = 0
    
    override func didMoveToView(view: SKView) {
        self.yValues = PositionUtils.getYvalues(self.frame)
        self.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        loadHighScore()
        doLoadAnimation()
    }
    
    func loadHighScore() -> Double{
        scores = scoreManager.scores
        println("total number scores \(scores.count)")
        if(scores.count != 0){
            for scoreObject in self.scores{
//                println("\(scoreObject.score) | \(scoreObject.checkPoint)")
                if (scoreObject.score > highScore) {
                    highScore = scoreObject.score
                    checkPoint = scoreObject.checkPoint
                }
            }
            println("highest \(self.highScore) \(self.checkPoint) ")
            self.scoreLabel.text = "best score " + CheckPointHelper.getFormattedScore(highScore)
            self.checkPoint = CheckPointHelper.checkPointForScore(self.highScore)
            self.previousHighest = self.highScore
            
        }
        return highScore
    }
    
    func doLoadAnimation() -> Void {
        
        self.title.position = self.center
        self.addChild(title)
        var wait = SKAction.waitForDuration(0.5)
        var moveUp = SKAction.moveToY(yValues[12]!, duration: 0.5)
        title.runAction(wait, completion: { () -> Void in
            self.title.runAction(moveUp, completion: { () -> Void in
                self.initializeMenuButtons();
            })
        })
    }
    
    func initializeMenuButtons() -> Void {
        
        if(scoreManager.userPrefs.userTookInstructions){
            
            playNew = GameUtils.getLabelNodeWithText("start afresh", name: "newButton");
            playNew.name = "newButton"
            playNew.fontSize = 30
            self.addChild(playNew)
            playNew.position = CGPointMake(center.x, yValues[7]!)
            playNew.runAction(fadeIn)
            
            var resumeText = self.checkPoint > 0 ? "resume checkpoint \(self.checkPoint)" :
                "resume checkpoint"
            playButton = GameUtils.getLabelNodeWithText(resumeText, name: "playButton");
            playButton.name = "playButton"
            self.addChild(playButton)
            playButton.fontSize = 30
            playButton.position = CGPointMake(center.x, yValues[5]!)
            playButton.runAction(fadeIn)
            
            scoreLabel.alpha = 0.0
            scoreLabel.position = CGPointMake(center.x, yValues[3]!)
            scoreLabel.fontColor = GameUtils.getBlueColor()
            scoreLabel.fontName = "Heiti TC Light"
            scoreLabel.fontSize = 30
            self.addChild(scoreLabel)
            scoreLabel.runAction(fadeIn)
            
            instructions = GameUtils.getLabelNodeWithText("instructions", name: "instructions");
            instructions.name = "instructions"
            self.addChild(instructions)
            instructions.fontSize = 30
            instructions.position = CGPointMake(center.x, yValues[1]!)
            instructions.runAction(fadeIn)
        }
        else if(!scoreManager.userPrefs.userTookInstructions){
            playNew = GameUtils.getLabelNodeWithText("start afresh", name: "newButton");
            playNew.name = "newButton"
            playNew.fontSize = 30
            self.addChild(playNew)
            playNew.position = CGPointMake(center.x, yValues[6]!)
            playNew.runAction(fadeIn)
            
            if(self.highScore == 0){
                scoreLabel.alpha = 0.0
                scoreLabel.fontSize = 30
                scoreLabel.position = CGPointMake(center.x, yValues[4]!)
                scoreLabel.fontColor = GameUtils.getBlueColor()
                scoreLabel.fontName = "Heiti TC Light"
                self.addChild(scoreLabel)
                scoreLabel.runAction(fadeIn)
            }else if (self.highScore > 0.1){
                
                var resumeText = self.checkPoint > 0 ? "resume checkpoint \(self.checkPoint)" :
                "resume checkpoint"
                playButton = GameUtils.getLabelNodeWithText(resumeText, name: "playButton");
                playButton.name = "playButton"
                self.addChild(playButton)
                playButton.fontSize = 30
                playButton.position = CGPointMake(center.x, yValues[4]!)
                playButton.runAction(fadeIn)
                
                scoreLabel.alpha = 0.0
                scoreLabel.position = CGPointMake(center.x, yValues[2]!)
                scoreLabel.fontColor = GameUtils.getBlueColor()
                scoreLabel.fontName = "Heiti TC Light"
                scoreLabel.fontSize = 30
                self.addChild(scoreLabel)
                scoreLabel.runAction(fadeIn)
            }
            
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        if(node.name == "newButton"){
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
        
            if(scoreManager.userPrefs.userTookInstructions){
                var scene = GameScene()
                scene.checkPoint = 0
                scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
                scene.size = skView.bounds.size
                scene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(scene, transition: trans)
            }else{
                var scene = InstructionScene()
                scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
                scene.size = skView.bounds.size
                scene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(scene, transition: trans)
            }
        }
        else if (node.name == "playButton"){
            var skView = self.view as SKView!
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            
            if(scoreManager.userPrefs.userTookInstructions){
                
                var gameScene = GameScene()
                gameScene.checkPoint = self.checkPoint
                println("entering with checkpoint \(gameScene.checkPoint)")
                gameScene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
                gameScene.size = skView.bounds.size
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(gameScene, transition: trans)
            }else{
                var scene = InstructionScene()
                scene.bridgeCheckPoint = self.checkPoint
                scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
                scene.size = skView.bounds.size
                scene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view!.presentScene(scene, transition: trans)
            }
        }

        else if (node.name == "instructions")
        {
            var skView = self.view as SKView!
            var scene = InstructionScene()
            scene.fromInstructionsButton = true
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(scene)
        }
        
        else if (node.name == "playUp")
        {
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            var scene = GameSceneReverse()
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }
    }
    
}