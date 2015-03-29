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
    var scoreManager = ScoreManager()
    var scores:Array<BestScore> = [];
    
    var playButton : SKLabelNode = SKLabelNode()
    var scoreLabel : SKLabelNode = SKLabelNode(text: "best score empty");
    var previousHighest : Int = 0
    var highScore : Int = 0
    
    
    
    override func didMoveToView(view: SKView) {
        self.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        loadHighScore()
        
        doLoadAnimation()
        
    }
    
    func loadHighScore() -> Int{
        scores = scoreManager.scores
        if(scores.count != 0){
            for scoreObject in self.scores{
                if (scoreObject.score > highScore) {
                    highScore = scoreObject.score
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
        var wait = SKAction.waitForDuration(1)
        var moveUp = SKAction.moveToY(center.y + 150, duration: 0.5)
        title.runAction(wait, completion: { () -> Void in
            self.title.runAction(moveUp, completion: { () -> Void in
                self.initializeMenuButtons();
            })
        })
    }
    
    func initializeMenuButtons() -> Void {
        self.scoreLabel.alpha = 0.0
        playButton = GameUtils.getLabelNodeWithText("play", name: "playButton");
        playButton.name = "playButton"
        self.addChild(playButton)
        playButton.position = CGPointMake(center.x, center.y - 150)
        playButton.runAction(fadeIn)
        scoreLabel.position = CGPointMake(center.x, center.y - 220)
        scoreLabel.fontColor = GameUtils.getBlueColor()
        scoreLabel.fontName = "Heiti TC Light"
        self.addChild(scoreLabel)
        scoreLabel.runAction(fadeIn)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        if(node.name == "playButton"){
            var trans = SKTransition.doorsOpenVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            var scene = GameScene()
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }
    }
    
}