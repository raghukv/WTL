//
//  PositionUtils.swift
//  Watch those Lines
//
//  Created by RaghuKV on 4/1/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation
import UIKit

class PositionUtils {
    
    class func getYvalues(frame: CGRect) -> Dictionary<Int, CGFloat>{
        var yValues : Dictionary<Int, CGFloat> = Dictionary<Int, CGFloat>();
        
        var factor = frame.height / 16
        for (var i = 1; i <= 16; i++){
            var yValue = CGFloat(i) * factor
            yValues[i] = yValue
        }
        return yValues;
    }
}