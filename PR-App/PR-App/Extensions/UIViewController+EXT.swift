//
//  UIViewController+EXT.swift
//  PR-App
//
//  Created by Jakub Homik on 19/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true, completion: completion)
        }
    }
    
    func createDismisKeyboardTapGesture() {
          let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
          view.addGestureRecognizer(tap)
      }
    
    func textFieldsShaker(inputFields: [CustomTextField]) {
        for x in inputFields {
            if x.text!.isEmpty {
                x.shake()
                
                func performAnimations(view: UIView) {
                    UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
                        self.view.alpha = 0.0
                    }) { (finished) in
                        UIView.transition(with: self.view, duration: 2, options: .transitionCrossDissolve, animations: {
                            self.view.alpha = 0.0
                        }, completion: nil)
                    }
                }
            }
        }
    }
}
