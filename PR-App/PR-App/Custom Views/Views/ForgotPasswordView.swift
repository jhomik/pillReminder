//
//  ForgotPasswordView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol ForgotPasswordDelegate: AnyObject {
    func resetPassword(withEmail: UserModel)
}

final class ForgotPasswordView: UIView {
    
    private let pillReminderLogo = UIImageView()
    private let forgotPasswordLabel = PillReminderMainCustomLabel(text: Constants.passwordRecover, alignment: .center, size: 20, weight: .semibold, color: .label)
    private let emailTextField = PillReminderMainCustomTextField(placeholderText: Constants.provideYourEmail, isPassword: false)
    private let sendPasswordButton = PillReminderMainCustomButton(text: Constants.sendPassword)
    weak var delegate: ForgotPasswordDelegate?
    
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
        let heightAnchorConstant: CGFloat = 60
        
        pillReminderLogo.image = Images.horizontalLogoImage
        self.addSubview(pillReminderLogo)
        
        pillReminderLogo.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureForgotPasswordLabel() {
        let heightAnchorConstant: CGFloat = 20
        
        self.addSubview(forgotPasswordLabel)
        
        forgotPasswordLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(pillReminderLogo)
            make.top.equalTo(pillReminderLogo.snp.bottom).offset(10)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureEmailTextField() {
        let topAnchorContant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 20
        
        self.addSubview(emailTextField)
        
        emailTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(pillReminderLogo)
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(topAnchorContant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureSendPasswordButton() {
        let topAnchorContant: CGFloat = 20
        let heightAnchorConstant: CGFloat = 40
        
        sendPasswordButton.addTarget(self, action: #selector(sendPasswordButtonTapped), for: .touchUpInside)
        self.addSubview(sendPasswordButton)
        
        sendPasswordButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(pillReminderLogo)
            make.height.equalTo(heightAnchorConstant)
            make.top.equalTo(emailTextField.snp.bottom).offset(topAnchorContant)
        }
    }
    
    @objc private func sendPasswordButtonTapped() {
        guard let email = emailTextField.text else { return }
//        delegate?.resetPassword(withEmail: email)
    }
}
