//
//  CheckPointHelper.swift
//  Watch those Lines
//
//  Created by RaghuKV on 4/1/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

class CheckPointDifficultyHelper {
    
    class func checkPointForScore(score: Int) -> Int {
        var nearestCheck : Float = Float(score / 30);
        var checkPoint = Int(floor(nearestCheck));
        return checkPoint
    }
    
}
