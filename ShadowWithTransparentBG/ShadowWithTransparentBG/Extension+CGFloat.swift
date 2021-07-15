//
//  Extension+CGFloat.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit


extension CGFloat {
    
    var radians : CGFloat {
        get {
            return (self * .pi)/180
        }
    }
    
}

extension FloatingPoint {
    var radians: Self {
        return self * .pi / Self(180)
    }
    
    func mod(between left: Self, and right: Self, byIncrementing interval: Self) -> Self {
        assert(interval > 0)
        assert(interval <= right - left)
        assert(right > left)
        
        if self >= left, self <= right {
            return self
        } else if self < left {
            return (self + interval).mod(between: left, and: right, byIncrementing: interval)
        } else {
            return (self - interval).mod(between: left, and: right, byIncrementing: interval)
        }
    }
}




