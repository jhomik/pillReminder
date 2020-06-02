//
//  CustomHeader.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CustomCellHeader: UICollectionReusableView {
    
    static let reuseID = "headerView"
    private var imageLogo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        imageLogo.image = UIImage(named: "title-logo")
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageLogo)
        
        NSLayoutConstraint.activate([
            imageLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageLogo.widthAnchor.constraint(equalToConstant: frame.width / 1.5),
            imageLogo.heightAnchor.constraint(equalToConstant: frame.height / 1.5),
        ])
    }
}
