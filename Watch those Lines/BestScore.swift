//
//  BestScore.swift
//  Rain
//
//  Created by RaghuKV on 3/22/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

// inherit from NSCoding to make instances serializable
class BestScore: NSObject, NSCoding {
    let score : Double = 0.0;
    let checkPoint : Int = 0;
    
    init(score:Double, checkPoint: Int) {
        self.score = score;
        self.checkPoint = checkPoint
    }
    
    required init(coder: NSCoder) {
        if let scoreX = coder.decodeObjectForKey("score")? as? Double {
            self.score = scoreX
        }

        if let checkPointX = coder.decodeObjectForKey("checkPoint")? as? Int {
            self.checkPoint = checkPointX
        }
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.checkPoint, forKey: "checkPoint");
    }
}
