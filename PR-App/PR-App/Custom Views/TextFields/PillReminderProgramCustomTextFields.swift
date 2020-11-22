//
//  PillReminderProgramCustomTextFields.swift
//  PR-App
//
//  Created by Jakub Homik on 28/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class PillReminderProgramCustomTextFields: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = 30
        self.layer.cornerRadius = 10
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        placeholder = placeholderText
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func configure() {
        let textFieldFontSize: CGFloat = 18
        self.backgroundColor = .systemBackground
        self.font = UIFont.italicSystemFont(ofSize: textFieldFontSize)
        self.adjustsFontSizeToFitWidth = false
    }
}
