//
//  LoginScreenVC.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class LoginScreenVC: UIViewController {
    
    let welcomeView = UIView()
    let welcomeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWelcomeView()
        performAnimations()
        
        view.backgroundColor = .systemPink
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        welcomeView.frame = view.bounds
        welcomeView.backgroundColor = .systemBackground
        
        welcomeView.addSubview(welcomeImage)
        welcomeImage.translatesAutoresizingMaskIntoConstraints = false
        welcomeImage.image = UIImage(named: "logo-PR")
        welcomeImage.frame = CGRect(x: 0, y: -20, width: 200, height: 180)
        
        NSLayoutConstraint.activate([
            welcomeImage.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeImage.centerYAnchor.constraint(equalTo: welcomeView.centerYAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: 200),
            welcomeImage.heightAnchor.constraint(equalToConstant: 180)
            
        ])
    }
    
    private func performAnimations() {
        
        welcomeImage.alpha = 0.0
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            self.welcomeImage.frame = CGRect(x: 0, y: -600, width: 200, height: 180)
            self.welcomeImage.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 2, delay: 1, options: .curveEaseOut, animations: {
                self.welcomeImage.alpha = 0.0
            }) { (finished) in
                UIView.transition(with: self.welcomeView, duration: 1, options: .transitionCrossDissolve, animations: {
                    self.welcomeView.alpha = 0.0
                }, completion: nil)
            }
        }
        
        
        
    }
}
