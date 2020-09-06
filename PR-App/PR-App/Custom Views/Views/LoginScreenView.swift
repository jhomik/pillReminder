//
//  LoginScreenView.swift
//  PR-App
//
//  Created by Jakub Homik on 06/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

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
}

final class LoginScreenView: UIView {
    
    private var scrollView = UIScrollView()
    private let stackViewLoginData = UIStackView()
    
    weak var delegate: LoginScreenAlertDelegate?
    weak var present: LoginScreenPresentForgotPasswordVC?
    weak var push: LoginScreenPresentUserMedicationInfoVC?
    
    private let userName = PillReminderMainCustomTextField(placeholderText: Constants.yourName, isPassword: false)
    private let emailInput = PillReminderMainCustomTextField(placeholderText: Constants.emailAddress, isPassword: false)
    private let passwordInput = PillReminderMainCustomTextField(placeholderText: Constants.password, isPassword: true)
    private let confirmInput = PillReminderMainCustomTextField(placeholderText: Constants.confirmPassword, isPassword: true)
    private let button = PillReminderMainCustomButton(text: Constants.logIn)
    private let logoImage = UIImageView(image: Images.logoImage)
    private var isSignUp = false
    private var segmentedController = UISegmentedControl()
    private var forgotPasswordButton = UIButton()
    lazy var viewModel = LoginScreenViewModel(loginEvents: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
         addSubview(scrollView)
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
             scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
         ])
     }
    
    private func configureLogoImage() {
        let horizontalConstant = UIScreen.main.bounds.width / 10
        let widthConstant = UIScreen.main.bounds.width * 0.8
        let heightConstant = widthConstant * 0.9239
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: heightConstant),
            logoImage.widthAnchor.constraint(equalToConstant: widthConstant),
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: horizontalConstant),
            logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func configureSegmentedView() {
        let selectedSegmentIndexValue: Int = 0
        let heightAnchorConstant: CGFloat = 30
        let topAnchorConstant: CGFloat = 10
        
        segmentedController = UISegmentedControl(items: [Constants.signIn, Constants.createAccount])
        segmentedController.apportionsSegmentWidthsByContent = false
        segmentedController.selectedSegmentTintColor = UIColor.mainColor
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.selectedSegmentIndex = selectedSegmentIndexValue
        segmentedController.addTarget(self, action: #selector(segmentedControllerChange), for: .valueChanged)
        scrollView.addSubview(segmentedController)
        
        NSLayoutConstraint.activate([
            segmentedController.leadingAnchor.constraint(equalTo: logoImage.leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: logoImage.trailingAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
            segmentedController.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: topAnchorConstant)
        ])
    }
    
    @objc func segmentedControllerChange(sender: UISegmentedControl) {
        isSignUp.toggle()
        self.userName.isHidden = !self.isSignUp
        self.confirmInput.isHidden = !self.isSignUp
        self.button.setTitle(isSignUp ? Constants.signUp : Constants.signIn, for: .normal)
    }

    private func configureStackViewLoginData() {
        let spacingConstant: CGFloat = 20
        let topAnchorConstant: CGFloat = 20
        
        userName.isHidden = true
        confirmInput.isHidden = true
        
        userName.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        confirmInput.delegate = self
        emailInput.keyboardType = .emailAddress
        
        stackViewLoginData.addArrangedSubview(userName)
        stackViewLoginData.addArrangedSubview(emailInput)
        stackViewLoginData.addArrangedSubview(passwordInput)
        stackViewLoginData.addArrangedSubview(confirmInput)
        stackViewLoginData.axis = .vertical
        stackViewLoginData.distribution = .equalSpacing
        stackViewLoginData.setCustomSpacing(spacingConstant, after: emailInput)
        
        stackViewLoginData.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackViewLoginData)
        
        NSLayoutConstraint.activate([
            stackViewLoginData.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            stackViewLoginData.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            stackViewLoginData.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: topAnchorConstant),
        ])
    }
    
    private func configureButton() {
          let horizontalConstant = UIScreen.main.bounds.width / 10
          let heightAnchorConstant: CGFloat = 40
          let topAnchorConstant: CGFloat = 25
          
          button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
          scrollView.addSubview(button)
          
          NSLayoutConstraint.activate([
              button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalConstant),
              button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalConstant),
              button.topAnchor.constraint(equalTo: stackViewLoginData.bottomAnchor, constant: topAnchorConstant),
              button.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
          ])
      }
    
    @objc private func buttonTapped() {
          guard let username = userName.text, let email = emailInput.text, let password = passwordInput.text, let confirmPassword = confirmInput.text else { return }
        
        self.isSignUp ? self.textFieldsShaker(inputFields: [userName, emailInput, passwordInput, confirmInput]) : self.textFieldsShaker(inputFields: [emailInput, passwordInput])
        
          viewModel.loginButtonTapped(userName: username, email: email, password: password, confirmPassword: confirmPassword, isSignUp: isSignUp)
          
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
            forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                forgotPasswordButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -bottomAnchorConstant),
                forgotPasswordButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                forgotPasswordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                forgotPasswordButton.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
            ])
        }
        
        @objc private func forgotButtonTapped() {
            present?.forgotPasswordViewController()
        }
    }

extension LoginScreenView: LoginScreenEvents {
    
    func onLoginSuccess() {
        delegate?.alertLoginSuccess(message: Alerts.userLogIn, withTime: nil, completion: {
            self.push?.userMedicationInfoViewController()
            self.emailInput.text = ""
            self.passwordInput.text = ""
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
            self.isSignUp.toggle()
            self.userName.isHidden = true
            self.confirmInput.isHidden = true
            self.userName.text = ""
            self.confirmInput.text = ""
        })
    }
    
    func createUserFailure(error: Error) {
        delegate?.alertCreateUserFailure(message: Errors.userIsNotVerified, withTime: nil, completion: nil)
    }
    
    func isEmailVerified() {
        delegate?.alertIsEmailVerified(message: Errors.userIsNotVerified, withTime: nil, completion: nil)
    }
}

extension LoginScreenView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName {
            emailInput.becomeFirstResponder()
        } else if textField == emailInput{
            passwordInput.becomeFirstResponder()
        } else if textField == passwordInput {
            if isSignUp {
                confirmInput.becomeFirstResponder()
            } else {
                passwordInput.resignFirstResponder()
                buttonTapped()
            }
        } else {
            confirmInput.resignFirstResponder()
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
