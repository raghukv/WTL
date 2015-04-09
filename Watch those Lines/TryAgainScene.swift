//
//  TryAgainScene.swift
//  Watch those Lines
//
//  Created by RaghuKV on 3/29/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TryAgainScene : SKScene {
    var tryAgainLabel : SKLabelNode!
    var menuLabel : SKLabelNode!
    var labelScore : SKLabelNode!
    var utils : GameUtils = GameUtils()
    var scoreMan : DataManager = DataManager()
    var score : Double = 0.0
    var checkPoint = 0;
    var yValues : Dictionary<Int, CGFloat>!
    
    convenience init(score: Double, checkPoint: Int){
        self.init()
        self.score = score
        self.checkPoint = checkPoint
    }
    
    override func didMoveToView(view: SKView) {
        
        yValues = PositionUtils.getYvalues(self.frame)
        
        var scoreString = "score  " + CheckPointHelper.getFormattedScore(self.score)
        labelScore = GameUtils.getLabelNodeWithText(scoreString, name: "scoreLabel")
        labelScore.alpha = 1.0
        labelScore.fontSize = 40
        labelScore.position = CGPointMake(self.frame.midX, yValues[10]!)
        self.addChild(labelScore)
        
        tryAgainLabel = GameUtils.getLabelNodeWithText("try Again", name: "tryAgain")
        tryAgainLabel.fontSize = 35
        tryAgainLabel.fontColor = GameUtils.getDarkColor()
        tryAgainLabel.alpha = 1.0
        tryAgainLabel.position = CGPointMake(self.frame.midX, yValues[6]!)
        self.addChild(tryAgainLabel)
        
        menuLabel = GameUtils.getLabelNodeWithText("menu", name: "menu")
        menuLabel.alpha = 1.0
        menuLabel.fontSize = 35
        menuLabel.fontColor = GameUtils.getDarkColor()
        menuLabel.position = CGPointMake(self.frame.midX, yValues[4]!)
        self.addChild(menuLabel)
        scoreMan.addNewScoreAndSave(score, checkPoint: checkPoint)
    }
    
    
    
    override func touchesBegan (touches: NSSet, withEvent event: UIEvent)
    {
        //Get touch coordinates in location view
        var touch : UITouch = touches.anyObject() as UITouch
        var touchPoint : CGPoint = touch.locationInNode(self)
        var node = self.nodeAtPoint(touchPoint) as SKNode
        var nodeName = node.name
        var tryAgain = "tryAgain"
        var menu = "menu"
        if(nodeName == tryAgain){
            
            var scene = GameScene()
            scene.checkPoint = self.checkPoint
//            scene.showInstructions = false;
            var trans = SKTransition.doorsOpenHorizontalWithDuration(0.5)
            var skView = self.view as SKView!
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
            
        }
        else if (nodeName == menu){
            
            var scene = MenuScene()
            var trans = SKTransition.doorsCloseVerticalWithDuration(0.5)
            var skView = self.view as SKView!
            scene.backgroundColor = SKColor(red: 245/255, green: 221/255, blue: 190/255, alpha: 1)
            scene.size = skView.bounds.size
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view!.presentScene(scene, transition: trans)
        }
    }

}
