//
//  InputTableViewCell.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    
    var inputField  = CustomInputField()
    var label       : CustomCellLabel!
    
    static let reuseID = "InputTableViewCell"

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
    
    func setInput(data: Double) {
        inputField.text = String(data)

    }
    
    private func configure() {
        label = CustomCellLabel()
        addSubview(inputField)
        addSubview(label)
        NSLayoutConstraint.activate([
            
            inputField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            inputField.heightAnchor.constraint(equalToConstant: 40),
            inputField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            inputField.widthAnchor.constraint(equalToConstant: 60),
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: inputField.leadingAnchor, constant: 10)
            
        ])
        
    }
}
