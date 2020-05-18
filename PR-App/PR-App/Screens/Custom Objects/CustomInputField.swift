//
//  CustomInputField.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/5/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CustomInputField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholderText: String, isPassword: Bool) {
        super.init(frame: .zero)
        configure()
        placeholder         = placeholderText
        isSecureTextEntry   = isPassword
    }
    
    private func configure() {
        borderStyle     = .roundedRect
        backgroundColor = .white
        textColor       = .black
        textAlignment   = .center
        translatesAutoresizingMaskIntoConstraints = false
        

    }
}
