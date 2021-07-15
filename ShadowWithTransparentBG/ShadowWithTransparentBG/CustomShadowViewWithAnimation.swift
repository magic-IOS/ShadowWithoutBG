//
//  CustomShadowView.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import Foundation
import UIKit

@IBDesignable
class CustomShadowViewWithAnimation : UIView {
    
    @IBInspectable var angle : Double = 310.0 {
        didSet {
            pauseIfAnimating()
            customLayer.angle = angle
            
        }
    }
    
    @IBInspectable var startAngle : CGFloat = 0.0
    
    
    override public class var layerClass: AnyClass {
        return CustomShadowViewLayer.self
    }
    
    @objc var customLayer : CustomShadowViewLayer {
        get {
            return layer as! CustomShadowViewLayer
        }
    }
    
    private var animationCompletionBlock: ((Bool) -> Void)?
    
    public override func prepareForInterfaceBuilder() {
        setInitialValues()
        refreshValues()
        customLayer.setNeedsDisplay()
    }
    
    private func setInitialValues() {
         //We always apply a 20% padding, stopping glows from being clipped
        backgroundColor = .clear
        
    }
    
    private func refreshValues() {
        customLayer.angle = angle
        customLayer.startAngle = startAngle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUIBasedOnStart()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.updateUIBasedOnStart()
    }
    
    func updateUIBasedOnStart() {
        self.refreshValues()
        customLayer.setNeedsDisplay()
    }
}




extension CustomShadowViewWithAnimation : CAAnimationDelegate  {
    
    public func animate(fromAngle: Double, toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        pauseIfAnimating()
        let animationDuration: TimeInterval
        if relativeDuration {
            animationDuration = duration
        } else {
            let traveledAngle = (toAngle - fromAngle).mod(between: 0.0, and: 360.0, byIncrementing: 360.0)
            let scaledDuration = TimeInterval(traveledAngle) * duration / 360.0
            animationDuration = scaledDuration
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(CustomShadowViewLayer.angle))
        animation.fromValue = fromAngle
        animation.toValue = toAngle
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        angle = toAngle
        animationCompletionBlock = completion
        
        customLayer.add(animation, forKey: "angle")
    }
    
    public func animate(toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        pauseIfAnimating()
        animate(fromAngle: Double(angle), toAngle: toAngle, duration: duration, relativeDuration: relativeDuration, completion: completion)
    }
    
    public func pauseAnimation() {
        guard let presentationLayer = customLayer.presentation() else { return }
        
        let currentValue = presentationLayer.angle
        customLayer.removeAllAnimations()
        angle = currentValue
    }
    
    private func pauseIfAnimating() {
        if isAnimating() {
            pauseAnimation()
        }
    }
    
    public func stopAnimation() {
        customLayer.removeAllAnimations()
        angle = 0
    }
    
    public func isAnimating() -> Bool {
        return customLayer.animation(forKey: "angle") != nil
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletionBlock?(flag)
        animationCompletionBlock = nil
    }
    
}

