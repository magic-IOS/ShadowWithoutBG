//
//  CustomShadowViewLayer.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit


@objcMembers
class CustomShadowViewLayer : CAShapeLayer {
    
    @NSManaged var angle: Double
    
    var startAngle : CGFloat = 0.0
    
    let outerShadowLayer = CAShapeLayer()
    let innerShadowLayer = CAShapeLayer()
    
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
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let customLayer = layer as? CustomShadowViewLayer {
            self.startAngle = customLayer.startAngle
            self.angle = customLayer.angle
        }
    }
    
    override init() {
        super.init()
        innerShadowLayer.fillRule = .evenOdd
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(angle) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    
    override func draw(in ctx: CGContext) {
        
        UIGraphicsPushContext(ctx)
        
//        print(angle)
        
        let radius = self.frame.size.height/2
        
        let canonicalAngle : CGFloat = CGFloat(angle.mod(between: 0.0, and: 360.0, byIncrementing: 360.0))
        let fromAngle = -startAngle.radians
        let endAngle: CGFloat = (-canonicalAngle - startAngle).radians
        
        
        let shapePath = UIBezierPath()
        shapePath.move(to: CGPoint(x: self.frame.size.height/2, y: self.frame.size.height/2))
        shapePath.addArc(
            withCenter: CGPoint(x: self.frame.size.height/2, y: self.frame.size.height/2),
            radius: radius,
            startAngle: fromAngle,
            endAngle: endAngle,
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
        
        ctx.saveGState()
        ctx.clear(bounds)
        
        let size = bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let imageCtx = UIGraphicsGetCurrentContext()
        
        
        
        imageCtx?.move(to: .zero)
        imageCtx?.addRect(bounds)
        
        
        
        let linecap: CGLineCap = .round
        imageCtx?.setLineCap(linecap)
        imageCtx?.setLineWidth(10)
        imageCtx?.drawPath(using: .fill)
        
        let drawMask: CGImage = UIGraphicsGetCurrentContext()!.makeImage()!
        UIGraphicsEndImageContext()
        
        ctx.saveGState()
        
        
        ctx.clip(to: bounds, mask: drawMask)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(bounds)
        
        outerShadowLayer.render(in: ctx)
        
        ctx.restoreGState()
        UIGraphicsPopContext()
        
    }
    
    
    
}
