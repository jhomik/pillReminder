//
//  CheckBoxTableViewCell.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {

        var checkBoxButton  = CheckBoxButton()
        var label           : CustomCellLabel!
        
        static let reuseID = "CheckBoxTableViewCell"

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func set(text: String) {
            label.text = text
        }
        
        private func configure() {
            label = CustomCellLabel()
            addSubview(checkBoxButton)
            addSubview(label)
            NSLayoutConstraint.activate([
                
                checkBoxButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                checkBoxButton.heightAnchor.constraint(equalToConstant: 40),
                checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                checkBoxButton.widthAnchor.constraint(equalToConstant: 60),
                
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                label.heightAnchor.constraint(equalToConstant: 40),
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: checkBoxButton.leadingAnchor, constant: 10)
                
            ])
            
        }
    }
