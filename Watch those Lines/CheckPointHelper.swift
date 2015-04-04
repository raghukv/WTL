//
//  CheckPointHelper.swift
//  Watch those Lines
//
//  Created by RaghuKV on 4/1/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

class CheckPointHelper {
    
    class func getFormattedScore (score: Double) -> String{
        var checkPoint = checkPointForScore(score)
        return String(format:"%.1f", score) + "|" + String(checkPoint)
    }
    
    class func checkPointForScore(score: Double) -> Int {
        var nearestCheck = score / 30;
        var checkPoint = Int(floor(nearestCheck));
        return checkPoint
    }
    
    class func baseScoreForCheckPoint(checkPoint: Int) -> Double{
        return Double(checkPoint * 30)
    }
    
    class func getDifficultyForCheckPoint(checkPoint: Int) -> (dropGenInt : Double, dropFallDur : Double){
        switch checkPoint{
        case 0:
            return (1.0, 4.0);
        case 1:
            return (0.88, 3.4);
        case 2:
            return (0.73, 2.6);
        case 3:
            return (0.58, 2.5);
        case 4:
            return (0.4299, 2.5);
        case 5:
            return (0.2799, 2.5);
        case 6:
            return (0.129, 2.5);
        default:
            return (1.0, 4.0);
            
        }
        
    }
    
}

/*

score 150
dropGenInterval 0.309999999999999
dropFallDuraion 2.5
score 180
dropGenInterval 0.309999999999999
dropFallDuraion 2.5
score 210
dropGenInterval 0.309999999999999
dropFallDuraion 2.5
score 240
dropGenInterval 0.309999999999999
dropFallDuraion 2.5

*/