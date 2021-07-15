//
//  ShapeLayer.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit

extension CAShapeLayer {
   
   var shapeShadow: ShapeShadow? {
       get {
           guard let shadowColor = shadowColor, shadowColor == fillColor else {
               return nil
           }
           return ShapeShadow(radius: shadowRadius, color: UIColor(cgColor: shadowColor), opacity: shadowOpacity, offset: shadowOffset)
       }
       set {
           shadowRadius = newValue?.radius ?? 0
           shadowColor = newValue?.color.cgColor
           shadowOpacity = newValue?.opacity ?? 0
           shadowOffset = newValue?.offset ?? .zero
           fillColor = newValue?.color.cgColor
       }
   }
   
}

