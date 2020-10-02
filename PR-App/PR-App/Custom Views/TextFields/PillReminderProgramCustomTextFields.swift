//
//  PillReminderProgramCustomTextFields.swift
//  PR-App
//
//  Created by Jakub Homik on 28/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class PillReminderProgramCustomTextFields: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        placeholder = placeholderText
    }
    
    private func configure() {
        let textFieldFontSize: CGFloat = 18
        self.frame.size.height = 30
        self.backgroundColor = .systemBackground
        self.font = UIFont.italicSystemFont(ofSize: textFieldFontSize)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
