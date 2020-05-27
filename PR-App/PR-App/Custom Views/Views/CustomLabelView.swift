//
//  CustomLabelView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class PillNameView: UIView {
    
    var medicationNamePlaceHolder = CustomLabel(text: "Pill name", alignment: .left)
    var medicationNameLabel = CustomLabel(text: "User Pill Name", alignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(medicationNamePlaceHolder)
        addSubview(medicationNameLabel)
        medicationNamePlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        medicationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationNamePlaceHolder.topAnchor.constraint(equalTo: self.topAnchor),
            medicationNamePlaceHolder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationNamePlaceHolder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            medicationNamePlaceHolder.bottomAnchor.constraint(equalTo: medicationNameLabel.topAnchor),
            
            medicationNameLabel.topAnchor.constraint(equalTo: medicationNamePlaceHolder.bottomAnchor),
            medicationNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            medicationNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
