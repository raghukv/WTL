//
//  MenuViewController.swift
//  Rain
//
//  Created by RaghuKV on 3/17/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scoreManager = DataManager()
    
    var scores:Array<BestScore> = [];
    
    var highScore : Double = 0.0
    
    var firstTime: Bool = true
    
    var previousHighest = 0.0
    
    override func viewDidLoad() {
        loadHighScore()
    }
    
    override func viewDidAppear(animated: Bool) {

        if(firstTime){
            UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.playButton.alpha = 1.0
                self.scoreLabel.alpha = 1.0
                }, completion: {
                    (finished: Bool) -> Void in
            })
            moveImage(self.titleImage)
        }else{
            loadHighScore()
//            if(loadHighScore() > self.previousHighest){
            
//            }
        }
        firstTime = false
    }
    
    func moveImage(view: UIImageView){
       
        var toPoint: CGPoint = CGPointMake(0.0, -130.0)
        var fromPoint : CGPoint = CGPointZero
        
        var movement = CABasicAnimation(keyPath: "position")
        movement.beginTime = CACurrentMediaTime()+0.5
        movement.additive = true
        movement.fromValue =  NSValue(CGPoint: fromPoint)
        movement.toValue =  NSValue(CGPoint: toPoint)
        movement.duration = 0.5
        movement.removedOnCompletion = false
        movement.fillMode = kCAFillModeForwards
        
        
        view.layer.addAnimation(movement, forKey: "move")
    }


    func loadHighScore() -> Double{
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
}