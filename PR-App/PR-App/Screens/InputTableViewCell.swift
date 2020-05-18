//
//  InputTableViewCell.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol TextPassBackDelegate : class {
    func update(updatedValue: Double, tag: Int)
}

class InputTableViewCell: UITableViewCell {
    weak var textPassBackDelegate   : TextPassBackDelegate!
    var inputField                  = CustomInputField()
    var label                       : CustomCellLabel!
    
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
        inputField.keyboardType = .decimalPad
        inputField.addTarget(self, action: #selector(changingText), for: .editingChanged)
        addSubview(label)
        let spacing : CGFloat = (UIScreen.main.bounds.width * 0.5) / 4
        let width   : CGFloat = UIScreen.main.bounds.width / 6
        let height  : CGFloat = UIScreen.main.bounds.width / 7

        NSLayoutConstraint.activate([
            
            inputField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            inputField.heightAnchor.constraint(equalToConstant: height),
            inputField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            inputField.widthAnchor.constraint(equalToConstant: width),
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: inputField.leadingAnchor, constant: 10)
            
        ])
        
    }
    
    @objc func changingText() {
        if label.text == "Quantity Per Bottle" {
            return
        } else {
            let newValue = Double(inputField.text!) ?? 0
            textPassBackDelegate.update(updatedValue: newValue, tag: inputField.tag)
        }

        
    }
}

