//
//  ShapeShadow.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit


public struct ShapeShadow {
    
    var radius: CGFloat
    var color: UIColor
    var opacity: Float
    var offset: CGSize
    
    public init(radius: CGFloat = 0, color: UIColor = .clear, opacity: Float = 1, offset: CGSize = .zero) {
        self.radius = radius
        self.color = color
        self.opacity = opacity
        self.offset = offset
    }
    
}
