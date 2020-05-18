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
            let spacing : CGFloat = (UIScreen.main.bounds.width * 0.5) / 4
            let width   : CGFloat = UIScreen.main.bounds.width / 6
            let height  : CGFloat = UIScreen.main.bounds.width / 7
            NSLayoutConstraint.activate([
                
                checkBoxButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
                checkBoxButton.heightAnchor.constraint(equalToConstant: height),
                checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                checkBoxButton.widthAnchor.constraint(equalToConstant: width),
                
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
                label.heightAnchor.constraint(equalToConstant: 40),
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.trailingAnchor.constraint(equalTo: checkBoxButton.leadingAnchor, constant: 10)
                
            ])
            
        }
    }
