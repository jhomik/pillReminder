//
//  LoginScreenVC.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
// 

import UIKit
import Firebase
import FirebaseAuth

final class LoginScreenVC: UIViewController {
    
    weak var coordinator: MainCoordinator?
    lazy var viewModel = LoginScreenViewModel(loginEvents: self)
    
    private let welcomeView = WelcomeView()
    private var scrollView = UIScrollView()
    
    private let emailInput = CustomTextField(placeholderText: "Email Address", isPassword: false)
    private let passwordInput = CustomTextField(placeholderText: "Password", isPassword: true)
    private let confirmInput = CustomTextField(placeholderText: "Confirm Password", isPassword: true)
    private let userNameInput = CustomTextField(placeholderText: "Provide your name", isPassword: false)
    private let button = CustomButton(text: "Log in")
    
    private let logoImage = UIImageView(image: Constants.logoImage)
    private var isSignUp = false
    private var segmentedController = UISegmentedControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureScrollView()
        configureViewController()
        configureLogoImage()
        configureSegmentedView()
        configureEmailInputField()
        configurePasswordInputField()
        configureConfirmInputField()
        
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        
        NSLayoutConstraint.activate([
            welcomeView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: button.topAnchor)
        ])
    }
    
    private func configureSegmentedView() {
        segmentedController = UISegmentedControl(items: ["Sign In", "Create Account"])
        segmentedController.apportionsSegmentWidthsByContent = false
        segmentedController.selectedSegmentTintColor = Constants.mainColor
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.selectedSegmentIndex = 0
        segmentedController.addTarget(self, action: #selector(segmentedControllerChange), for: .valueChanged)
        scrollView.addSubview(segmentedController)
        
        NSLayoutConstraint.activate([
            segmentedController.leadingAnchor.constraint(equalTo: logoImage.leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: logoImage.trailingAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30),
            segmentedController.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func segmentedControllerChange(sender: UISegmentedControl) {
        isSignUp.toggle()
        confirmInput.isHidden = !self.isSignUp
        //        usernameInput.text? = ""
        //        passwordInput.text? = ""
        //        confirmInput.text? = ""
        isSignUp ? (self.passwordInput.placeholder = "Create Password") : (self.passwordInput.placeholder = "Password")
        isSignUp ? self.button.setTitle("Sign Up", for: .normal) : self.button.setTitle("Log In", for: .normal)
        
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
    
    private func configureEmailInputField() {
        emailInput.delegate = self
        scrollView.addSubview(emailInput)
        
        NSLayoutConstraint.activate([
            emailInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            emailInput.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            emailInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            emailInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordInputField() {
        passwordInput.delegate = self
        scrollView.addSubview(passwordInput)
        NSLayoutConstraint.activate([
            passwordInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 10),
            passwordInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            passwordInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        let horizontalConstant  = UIScreen.main.bounds.width / 10
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalConstant),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalConstant),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func buttonTapped() {
        guard let email = emailInput.text, let password = passwordInput.text, let confirmPassword = confirmInput.text else { return }
        viewModel.loginButtonTapped(email: email, password: password, confirmPassword: confirmPassword)
    }
    
    private func configureConfirmInputField() {
        confirmInput.delegate = self
        scrollView.addSubview(confirmInput)
        
        NSLayoutConstraint.activate([
            confirmInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            confirmInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 10),
            confirmInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            confirmInput.heightAnchor.constraint(equalToConstant: 50)
        ])
        confirmInput.isHidden = true
    }
}

extension LoginScreenVC: LoginScreenEvents {
    
    func onLoginSuccess() {
        self.coordinator?.didLogin()
    }
    
    func onLoginFailure(error: Error) {
        self.showAlert(message: error.localizedDescription, completion: nil)
    }
    
}

extension LoginScreenVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailInput {
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
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
}

