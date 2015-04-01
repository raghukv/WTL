//
//  UserPreferences.swift
//  Watch those Lines
//
//  Created by RaghuKV on 3/31/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

class UserPreferences: NSObject, NSCoding {
    
    var userTookInstructions : Bool = false
    
    init(userTookInstr : Bool){
        self.userTookInstructions = userTookInstr
    }
    
    required init(coder: NSCoder) {
        self.userTookInstructions = coder.decodeObjectForKey("userTookInstructions")! as Bool;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.userTookInstructions, forKey: "userTookInstructions")
    }
}
