//
//  ViewController.swift
//  ShadowWithTransparentBG
//
//  Created by Mitul on 15/07/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customShadowView: CustomShadowViewWithAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        self.setupAnimation()
    }

    func setupAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            print(360)
            self.customShadowView.animate(toAngle: 360, duration: 1.0, completion: nil)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+6) {
            print(270)
            self.customShadowView.animate(toAngle: 270, duration: 1.0, completion: nil)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+9) {
            print(180)
            self.customShadowView.animate(toAngle: 180, duration: 1.0, completion: nil)
           
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+12) {
            print(90)
            self.customShadowView.animate(toAngle: 90, duration: 1.0, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+15) {
            print(0)
            self.customShadowView.animate(toAngle: 0, duration: 1.0, completion: nil)
        }
    }

}

