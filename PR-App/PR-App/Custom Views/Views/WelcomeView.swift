//
//  WelcomeView.swift
//  PR-App
//
//  Created by Jakub Homik on 08/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    private let welcomeImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWelcomeView()
        performAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWelcomeView() {
        self.frame = bounds
        self.backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        welcomeImage.image = Constants.logoImage
        
        addSubview(welcomeImage)
        welcomeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: 200),
            welcomeImage.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func performAnimations() {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            self.welcomeImage.alpha = 0.0
        }) { (finished) in
            UIView.transition(with: self, duration: 2, options: .transitionCrossDissolve, animations: {
                self.alpha = 0.0
            }, completion: nil)
        }
    }
}
