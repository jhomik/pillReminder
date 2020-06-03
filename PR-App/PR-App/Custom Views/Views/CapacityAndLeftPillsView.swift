//
//  CapacityAndLeftPillsView.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CapacityAndLeftPillsView: UIView {
    
    private var titleLabel = CustomLabel(text: "Capacity", alignment: .left, size: 24, weight: .bold, color: .label)
    private var inputLabel = CustomLabel(text: "50 pills left", alignment: .left, size: 12, weight: .medium, color: .systemGray2)
    
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: inputLabel.topAnchor, constant: -6),
            
            inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

