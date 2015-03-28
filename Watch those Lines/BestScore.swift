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
    
    init(score:Int) {
        self.score = score;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as Int;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
    }
}
