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
    let score : Int = 0;
    let checkPoint : Int = 0;
    
    init(score:Int, checkPoint: Int) {
        self.score = score;
        self.checkPoint = checkPoint
    }
    
    required init(coder: NSCoder) {
        if let rasikesh = coder.decodeObjectForKey("score")? as? Int {
            self.score = rasikesh
        }
//        self.score = coder.decodeObjectForKey("score")? as Int;
        if let rasik = coder.decodeObjectForKey("checkPoint")? as? Int {
            self.checkPoint = rasik
        }
        
 //       self.checkPoint = coder.decodeObjectForKey("checkPoint")! as Int;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.checkPoint, forKey: "checkPoint");
    }
}
