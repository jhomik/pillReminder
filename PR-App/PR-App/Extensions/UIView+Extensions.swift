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
        animation .toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func performAnimationsFadeOut(view: UIImageView) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }) { _ in
            UIView.transition(with: self, duration: 2, options: .transitionCrossDissolve, animations: {
                self.alpha = 0.0
            }, completion: nil)
        }
    }
    
    func textFieldsShaker(inputFields: [PillReminderMainCustomTextField]) {
        for field in inputFields {
            if let fieldText = field.text, fieldText.isEmpty {
                field.shake()
            }
        }
    }
    
    func setFlowLayout() -> UICollectionViewFlowLayout {
        let width = self.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        let heightHeaderSize: CGFloat = 80

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        flowLayout.headerReferenceSize = CGSize(width: self.frame.width, height: heightHeaderSize)
        
        return flowLayout
    }
}
