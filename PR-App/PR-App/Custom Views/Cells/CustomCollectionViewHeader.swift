//
//  CustomCollectionViewHeader.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomCollectionViewHeader: UICollectionReusableView {
    
    static let reuseID = "headerView"
    private var imageLogo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalLogoImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHorizontalLogoImage() {
        let multiplierWidthAndHeightConstant: CGFloat = 1.5
        
        imageLogo.image = Images.horizontalLogoImage
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageLogo)
        
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageLogo.widthAnchor.constraint(equalToConstant: frame.width / multiplierWidthAndHeightConstant),
            imageLogo.heightAnchor.constraint(equalToConstant: frame.height / multiplierWidthAndHeightConstant)
        ])
    }
}
