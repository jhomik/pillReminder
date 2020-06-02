//
//  CustomLabelView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class PillNameView: UIView {
    
    private var titleLabel = CustomLabel(text: "Pill name", alignment: .left, size: 10, weight: .bold, color: .systemGray2)
    private var inputLabel = CustomLabel(text: "Metocard", alignment: .left, size: 24, weight: .medium, color: Constants.mainColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(inputLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: inputLabel.topAnchor),
            
            inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
