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
    
    private var input: NSAttributedString = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.mainColor])
    
    private lazy var titleLabel: PillReminderMainCustomLabel = {
        return PillReminderMainCustomLabel(text: self.title, alignment: .left)
    }()
    private lazy var inputLabel: PillReminderMainCustomLabel = {
        return PillReminderMainCustomLabel(text: self.input, alignment: .left)
    }()
    
    convenience init(title: NSAttributedString, input: NSAttributedString) {
        self.init(frame: .zero)
        self.title = title
        self.input = input
        configureTitleLabel()
        configureInputLabel()
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func configureInputLabel() {
        let bottomAnchorConstant: CGFloat = 12
        
        addSubview(inputLabel)
        inputLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            inputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomAnchorConstant)
        ])
    }
    
    func updateInputValue(_ text: NSAttributedString) {
        self.inputLabel.updateText(text)
    }
}
