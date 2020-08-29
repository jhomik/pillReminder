//
//  WelcomeView.swift
//  PR-App
//
//  Created by Jakub Homik on 08/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    //final class? 
    private let welcomeImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWelcomeView()
        performAnimations(view: welcomeImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWelcomeView() {
        self.frame = bounds
        self.backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        welcomeImage.image = Images.logoImage
        
        addSubview(welcomeImage)
        welcomeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: 260),
            welcomeImage.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
}
