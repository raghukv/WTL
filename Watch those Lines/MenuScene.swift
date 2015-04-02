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
    var scoreLabel : SKLabelNode = SKLabelNode(text: "best score empty");
    var previousHighest : Int = 0
    var highScore : Int = 0
    var checkPoint : Int = 0
    
    var reverse : SKLabelNode = SKLabelNode()
    
    var yValues : Dictionary<Int, CGFloat> = Dictionary<Int, CGFloat>();
    
    override func didMoveToView(view: SKView) {
        
        self.yValues = PositionUtils.getYvalues(self.frame)
        
        self.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        loadHighScore()

        doLoadAnimation()
        println(checkPoint)
    }
    
    func loadHighScore() -> Int{
        scores = scoreManager.scores
        if(scores.count != 0){
            for scoreObject in self.scores{
                if (scoreObject.score > highScore) {
                    highScore = scoreObject.score
                    checkPoint = scoreObject.checkPoint
                }
            }
            self.scoreLabel.text = "best score " + String(format:"%d", self.highScore)
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

        playButton = GameUtils.getLabelNodeWithText("play", name: "playButton");
        playButton.name = "playButton"
        self.addChild(playButton)
        playButton.position = CGPointMake(center.x, yValues[6]!)
        playButton.runAction(fadeIn)
        
        scoreLabel.alpha = 0.0
        scoreLabel.position = CGPointMake(center.x, yValues[4]!)
        scoreLabel.fontColor = GameUtils.getBlueColor()
        scoreLabel.fontName = "Heiti TC Light"
        self.addChild(scoreLabel)
        scoreLabel.runAction(fadeIn)
        
        
        instructions = GameUtils.getLabelNodeWithText("instructions", name: "instructions");
        instructions.name = "instructions"
        self.addChild(instructions)
        instructions.fontSize = 33
        instructions.position = CGPointMake(center.x, yValues[2]!)
        instructions.runAction(fadeIn)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        if(node.name == "playButton"){
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            var scene : SKScene!
            if(scoreManager.userPrefs.userTookInstructions){
                scene = GameScene()
            }else{
                scene = InstructionScene()
            }
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
            
        }else if (node.name == "playUp"){
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            var scene = GameSceneReverse()
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }else if (node.name == "instructions"){
            var skView = self.view as SKView!
            var scene = InstructionScene()
            scene.fromInstructionsButton = true
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(scene)
            
        }
    }
    
}