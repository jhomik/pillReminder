//
//  WelcomeView.swift
//  PR-App
//
//  Created by Jakub Homik on 08/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

final class WelcomeView: UIView {
    
    private let welcomeImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureWelcomeView()
        performAnimationsFadeOut(view: welcomeImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.frame = bounds
        self.backgroundColor = .systemBackground
    }
    
    private func configureWelcomeView() {
        let widthAnchorConstant: CGFloat = 260
        let heightAnchorConstant: CGFloat = 240
        
        welcomeImage.image = Images.logoImage
        self.addSubview(welcomeImage)
        
        welcomeImage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.equalTo(heightAnchorConstant)
            make.width.equalTo(widthAnchorConstant)
        }
    }
}
