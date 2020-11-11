//
//  PillReminderMainCustomTextField.swift
//  PR-App
//
//  Created by Jakub Homik on 02/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class PillReminderMainCustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    convenience init(placeholderText: String, isPassword: Bool) {
        self.init(frame: .zero)
        placeholder = placeholderText
        isSecureTextEntry = isPassword
    }
    
    private func configure() {
        let textFieldShadowOpactiy: Float = 0.5
        let textFieldShadowRadius: CGFloat = 0.0
        let textFieldFontSize: CGFloat = 18
        let shadowOffsetWidth: CGFloat = 0.0
        let shadowOffsetHeight: CGFloat = 0.2
        
        self.backgroundColor = UIColor.backgroundColor
        self.font = UIFont.italicSystemFont(ofSize: textFieldFontSize)
        self.layer.backgroundColor = UIColor.backgroundColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        self.layer.shadowOpacity = textFieldShadowOpactiy
        self.layer.shadowRadius = textFieldShadowRadius
        self.layer.shadowColor = UIColor.textFieldUnderline.cgColor
        self.autocapitalizationType = .none
        self.adjustsFontSizeToFitWidth = true
    }
}
