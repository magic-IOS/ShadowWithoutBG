//
//  CustomShadowView.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit


class CustomShadowView : UIView {
    
    private var screenPath: UIBezierPath = {
        let path = UIBezierPath()
        let main = UIScreen.main.bounds
        path.move(to: CGPoint(x: -main.width, y: -main.height))
        path.addLine(to: CGPoint(x: main.width, y: -main.height))
        path.addLine(to: CGPoint(x: main.width, y: main.height))
        path.addLine(to: CGPoint(x: -main.width, y: main.height))
        path.close()
        return path
    }()
    
    let outerShadowLayer = CAShapeLayer()
    let innerShadowLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let raduis = self.frame.size.height/2 //labelHeight / 2
        let shapePath = UIBezierPath()
        shapePath.move(to: CGPoint(x: self.frame.size.height/2, y: self.frame.size.height/2))
        shapePath.addArc(
            withCenter: CGPoint(x: self.frame.size.height/2, y: self.frame.size.height/2),
            radius: raduis,
            startAngle: self.deg2rad(-90),
            endAngle: self.deg2rad(180),
            clockwise: true
        )
        
        outerShadowLayer.isHidden = false
        outerShadowLayer.path = shapePath.cgPath
        outerShadowLayer.shapeShadow = ShapeShadow(radius: 20, color: .green)
        outerShadowLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = {
                let path = UIBezierPath()
                path.append(shapePath)
                path.append(screenPath)
                path.usesEvenOddFillRule = true
                return path.cgPath
            }()
            cutLayer.fillRule = .evenOdd
            return cutLayer
        }()
        self.layer.addSublayer(outerShadowLayer)
        
        let innerShadow = ShapeShadow(radius: 20, color: .green)
        innerShadowLayer.isHidden = false
        innerShadowLayer.frame = bounds
        innerShadowLayer.shapeShadow = innerShadow
        innerShadowLayer.path = {
            let path = UIBezierPath()
            path.append(screenPath)
            path.append(shapePath)
            return path.cgPath
        }()
        innerShadowLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            return cutLayer
        }()
        
        innerShadowLayer.fillRule = .evenOdd
        
        self.layer.addSublayer(innerShadowLayer)
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
    
}
