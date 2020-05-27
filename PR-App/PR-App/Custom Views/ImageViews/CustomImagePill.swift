//
//  CustomImagePill.swift
//  PR-App
//
//  Created by Jakub Homik on 23/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CustomImagePill: UIImageView {
    
    let pillImage = UIImage(systemName: "camera")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        image = pillImage
        clipsToBounds = true
        backgroundColor = .systemGray
        alpha = 0.4
        layer.cornerRadius = 16
    }
}
