//
//  TitleAndInputMedicationView.swift
//  PR-App
//
//  Created by Jakub Homik on 17/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class TitleAndInputMedicationView: UIView {
    
    private var title: NSAttributedString = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .bold), .foregroundColor: UIColor.systemGray2])
    
    private var input: NSAttributedString = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: Constants.mainColor])
    
    private lazy var titleLabel: CustomLabel = {
        return CustomLabel(text: self.title, alignment: .left)
    }()
    private lazy var inputLabel: CustomLabel = {
        return CustomLabel(text: self.input, alignment: .left)
    }()
    
    convenience init(title: NSAttributedString, input: NSAttributedString) {
        self.init(frame: .zero)
        self.title = title
        self.input = input
        configure()
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
            titleLabel.bottomAnchor.constraint(equalTo: inputLabel.topAnchor),
            
            inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
    
    func updateInputValue(_ text: NSAttributedString) {
        self.inputLabel.updateText(text)
    }
    
}
