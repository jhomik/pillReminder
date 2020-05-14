//
//  CustomCellLabel.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CustomCellLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        configure()
        self.text = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        textAlignment                               = .left
        
    }

}
