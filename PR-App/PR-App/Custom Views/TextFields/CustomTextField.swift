//
//  CustomTextField.swift
//  PR-App
//
//  Created by Jakub Homik on 02/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String, isPassword: Bool) {
        self.init(frame: .zero)
        placeholder = placeholderText
        isSecureTextEntry = isPassword
    }
    
    private func configure() {
        self.font = UIFont.italicSystemFont(ofSize: 18)
        self.layer.backgroundColor = Constants.backgroundColor.cgColor
        self.layer.shadowOffset  = CGSize(width: 0.0, height: 0.2)
        self.layer.shadowOpacity  = 0.5
        self.layer.shadowRadius  = 0.0
        self.layer.shadowColor   = UIColor.label.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocapitalizationType = .none
    }
}
