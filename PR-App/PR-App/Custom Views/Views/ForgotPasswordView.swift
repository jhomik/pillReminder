//
//  ForgotPasswordView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol ForgotPasswordDelegate: class {
    func resetPassword(withEmail: String)
}

class ForgotPasswordView: UIView {
    
    private let pillReminderLogo = UIImageView()
    private let forgotPasswordLabel = CustomLabel(text: "Password recover", alignment: .center, size: 20, weight: .semibold, color: .label)
    private let emailTextField = CustomTextField(placeholderText: "Provide your email", isPassword: false)
    private let sendPasswordButton = CustomButton(text: "Send password")
    var delegate: ForgotPasswordDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePillReminderLogo()
        configureForgotPasswordLabel()
        configureEmailTextField()
        configureSendPasswordButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePillReminderLogo() {
        pillReminderLogo.image = Images.horizontalLogoImage
        
        self.addSubview(pillReminderLogo)
        pillReminderLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pillReminderLogo.topAnchor.constraint(equalTo: self.topAnchor),
            pillReminderLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillReminderLogo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pillReminderLogo.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureForgotPasswordLabel() {
        
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forgotPasswordLabel)
        
        NSLayoutConstraint.activate([
            forgotPasswordLabel.topAnchor.constraint(equalTo: pillReminderLogo.bottomAnchor, constant: 10),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: pillReminderLogo.leadingAnchor),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: pillReminderLogo.trailingAnchor),
            forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureEmailTextField() {
        
        self.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: pillReminderLogo.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: pillReminderLogo.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureSendPasswordButton() {
        sendPasswordButton.addTarget(self, action: #selector(sendPasswordButtonTapped), for: .touchUpInside)
        self.addSubview(sendPasswordButton)
        sendPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            sendPasswordButton.leadingAnchor.constraint(equalTo: pillReminderLogo.leadingAnchor),
            sendPasswordButton.trailingAnchor.constraint(equalTo: pillReminderLogo.trailingAnchor),
            sendPasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func sendPasswordButtonTapped() {
        guard let email = emailTextField.text else { return }
        delegate?.resetPassword(withEmail: email)
        print("test")
    }
}
