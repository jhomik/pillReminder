//
//  CustomProgramTextField.swift
//  PR-App
//
//  Created by Jakub Homik on 03/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomProgramTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        self.placeholder = placeholderText
    }
    
    private func configure() {
        self.font = UIFont.italicSystemFont(ofSize: 16)
        self.layer.backgroundColor = Constants.backgroundColor.cgColor
        self.layer.borderWidth = 1
        self.textAlignment = .center
        self.layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        autocapitalizationType = .none
    }
}
