//
//  LoginScreenView.swift
//  PR-App
//
//  Created by Jakub Homik on 06/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginScreenPresentUserMedicationInfoVC: AnyObject {
    func userMedicationInfoViewController()
}

protocol LoginScreenPresentForgotPasswordVC: AnyObject {
    func forgotPasswordViewController()
}

protocol LoginScreenAlertDelegate: AnyObject {
    func alertLoginSuccess(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
    func alertLoginFailure(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
    func alertCreateUserSuccess(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
    func alertCreateUserFailure(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
    func alertIsEmailVerified(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
    func alertIsPasswordMatch(message: String, withTime: DispatchTime?, completion: (() -> Void)?)
}

final class LoginScreenView: UIView {
    
    private let stackViewLoginData = UIStackView()
    private let mainButtonEvent = PillReminderMainCustomButton(text: Constants.signIn)
    private let logoImage = UIImageView(image: Images.logoImage)
    private let viewModel: LoginScreenViewModel
    
    private(set) var userNameTextField = PillReminderMainCustomTextField(placeholderText: Constants.yourName, isPassword: false)
    private(set) var emailTextField = PillReminderMainCustomTextField(placeholderText: Constants.emailAddress, isPassword: false)
    private(set) var passwordTextField = PillReminderMainCustomTextField(placeholderText: Constants.password, isPassword: true)
    private(set) var confirmTextField = PillReminderMainCustomTextField(placeholderText: Constants.confirmPassword, isPassword: true)
    
    private var scrollView = UIScrollView()
    private var segmentedController = UISegmentedControl()
    private var forgotPasswordButton = UIButton()
    
    weak var delegate: LoginScreenAlertDelegate?
    weak var present: LoginScreenPresentForgotPasswordVC?
    weak var push: LoginScreenPresentUserMedicationInfoVC?
    
    init(viewModel: LoginScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        viewModel.loginEvents = self
        configureScrollView()
        configureLogoImage()
        configureSegmentedView()
        configureStackViewLoginData()
        configureButton()
        configureForgotPasswordButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.self)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func configureLogoImage() {
        let heightAnchorMultiplier = viewModel.setHeightAnchorMulitplier()
        let widthAnchorMultiplier = viewModel.setWidthAnchorMultiplier()
        let topAnchorConstant: CGFloat = 20
        
        scrollView.addSubview(logoImage)
        
        logoImage.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(heightAnchorMultiplier)
            make.width.equalTo(self).multipliedBy(widthAnchorMultiplier)
            make.top.equalTo(scrollView.snp.top).offset(topAnchorConstant)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
    }
    
    private func configureSegmentedView() {
        let selectedSegmentIndexValue: Int = 0
        let heightAnchorConstant: CGFloat = 30
        let topAnchorConstant: CGFloat = 10
        
        segmentedController = UISegmentedControl(items: [Constants.signIn, Constants.createAccount])
        segmentedController.apportionsSegmentWidthsByContent = false
        segmentedController.selectedSegmentTintColor = UIColor.mainColor
        segmentedController.selectedSegmentIndex = selectedSegmentIndexValue
        segmentedController.addTarget(self, action: #selector(segmentedControllerChange), for: .valueChanged)
        scrollView.addSubview(segmentedController)
        
        segmentedController.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(topAnchorConstant)
            make.leading.trailing.equalTo(logoImage)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc func segmentedControllerChange(sender: UISegmentedControl) {
        viewModel.toogleIsSignUp()
        
        self.userNameTextField.isHidden = viewModel.checkIfSignUp()
        self.confirmTextField.isHidden = viewModel.checkIfSignUp()
        self.mainButtonEvent.setTitle(viewModel.setTitleForButton(), for: .normal)
    }
    
    private func configureStackViewLoginData() {
        let spacingConstant: CGFloat = 20
        let topAnchorConstant: CGFloat = 20
        
        userNameTextField.isHidden = true
        confirmTextField.isHidden = true
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        
        stackViewLoginData.addArrangedSubview(userNameTextField)
        stackViewLoginData.addArrangedSubview(emailTextField)
        stackViewLoginData.addArrangedSubview(passwordTextField)
        stackViewLoginData.addArrangedSubview(confirmTextField)
        stackViewLoginData.axis = .vertical
        stackViewLoginData.distribution = .equalSpacing
        stackViewLoginData.setCustomSpacing(spacingConstant, after: emailTextField)
        
        scrollView.addSubview(stackViewLoginData)
        
        stackViewLoginData.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(segmentedController)
            make.top.equalTo(segmentedController.snp.bottom).offset(topAnchorConstant)
        }
    }
    
    private func configureButton() {
        let heightAnchorConstant: CGFloat = 40
        let topAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE ? 9 : 25
        
        mainButtonEvent.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        scrollView.addSubview(mainButtonEvent)
        
        mainButtonEvent.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(logoImage)
            make.top.equalTo(stackViewLoginData.snp.bottom).offset(topAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc private func buttonTapped() {
        let userModel = UserModel(loginScreen: self)
        
        // TODO: Logic? Should be in the ViewModel?
        viewModel.checkIfSignUp() ? self.textFieldsShaker(inputFields: [emailTextField, passwordTextField]) : self.textFieldsShaker(inputFields: [userNameTextField, emailTextField, passwordTextField, confirmTextField])
        
        viewModel.loginButtonTapped(userModel: userModel)
    }
    
    private func configureForgotPasswordButton() {
        let forgotPasswordButtonFontsize: CGFloat = 14
        let bottomAnchorConstant: CGFloat = 15
        let heightAnchorConstant: CGFloat = 10
        
        forgotPasswordButton.setTitle(Constants.forgotYourPassword, for: .normal)
        forgotPasswordButton.setTitleColor(.label, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        forgotPasswordButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: forgotPasswordButtonFontsize)
        
        self.addSubview(forgotPasswordButton)
        
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(safeAreaLayoutGuide.self).offset(-bottomAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc private func forgotButtonTapped() {
        present?.forgotPasswordViewController()
    }
}

extension LoginScreenView: LoginScreenEvents {
    func isPasswordMatch() {
        delegate?.alertIsPasswordMatch(message: Alerts.passwordMatch, withTime: nil, completion: nil)
    }
    
    func onLoginSuccess() {
        delegate?.alertLoginSuccess(message: Alerts.userLogIn, withTime: nil, completion: {
            self.push?.userMedicationInfoViewController()
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        })
        print("User logged successfully")
    }
    
    func onLoginFailure(error: Error) {
        delegate?.alertLoginFailure(message: error.localizedDescription, withTime: nil, completion: nil)
    }
    
    func createUserSuccess() {
        let selectedSegmentIndexValue: Int = 0
        
        delegate?.alertCreateUserSuccess(message: Alerts.emailActivation, withTime: nil, completion: {
            self.segmentedController.selectedSegmentIndex = selectedSegmentIndexValue
            self.viewModel.toogleIsSignUp()
            self.userNameTextField.isHidden = true
            self.confirmTextField.isHidden = true
            self.userNameTextField.text = ""
            self.confirmTextField.text = ""
            self.mainButtonEvent.setTitle(Constants.signIn, for: .normal)
        })
    }
    
    func createUserFailure(error: Error) {
        delegate?.alertCreateUserFailure(message: error.localizedDescription, withTime: nil, completion: nil)
    }
    
    func isEmailVerified() {
        delegate?.alertIsEmailVerified(message: Errors.userIsNotVerified, withTime: nil, completion: nil)
    }
}

extension LoginScreenView: UITextFieldDelegate {
    // TODO: Logic - how to put this inside ViewModel?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if viewModel.checkIfSignUp() {
                confirmTextField.becomeFirstResponder()
            } else {
                passwordTextField.resignFirstResponder()
                buttonTapped()
            }
        } else {
            confirmTextField.resignFirstResponder()
            buttonTapped()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
}
