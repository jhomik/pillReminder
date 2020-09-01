//
//  UIView+Ext.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/6/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func performAnimationsFadeOut(view: UIImageView) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }) { (finished) in
            UIView.transition(with: self, duration: 2, options: .transitionCrossDissolve, animations: {
                self.alpha = 0.0
            }, completion: nil)
        }
    }
}
