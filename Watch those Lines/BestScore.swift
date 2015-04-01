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
    let score:Int;
    let checkPoint:Int;
    
    init(score:Int, checkPoint: Int) {
        self.score = score;
        self.checkPoint = checkPoint
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as Int;
        self.checkPoint = coder.decodeObjectForKey("checkPoint") as Int;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.checkPoint, forKey: "checkPoint");
    }
}
