//
//  LoginScreenVC.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
// 

import UIKit
import FirebaseAuth

final class LoginScreenVC: UIViewController {
    
    lazy var viewModel = LoginScreenViewModel(loginEvents: self)
    
    private let welcomeView = WelcomeView()
    private var scrollView = UIScrollView()
    private let stackViewLoginData = UIStackView()
    
    private let userName = CustomTextField(placeholderText: "Your name", isPassword: false)
    private let emailInput = CustomTextField(placeholderText: "Email Address", isPassword: false)
    private let passwordInput = CustomTextField(placeholderText: "Password", isPassword: true)
    private let confirmInput = CustomTextField(placeholderText: "Confirm Password", isPassword: true)
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
        checkUserSession()
        configureButton()
        configureScrollView()
        configureViewController()
        configureLogoImage()
        configureSegmentedView()
        configureStackViewLoginData()
        createDismisKeyboardTapGesture()
        
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
    
    @objc func segmentedControllerChange(sender: UISegmentedControl) {
        isSignUp.toggle()
        self.userName.isHidden = !self.isSignUp
        self.confirmInput.isHidden = !self.isSignUp
        self.passwordInput.placeholder = isSignUp ? "Create Password" : "Password"
        self.button.setTitle(isSignUp ? "Sign Up" : "Log In", for: .normal)
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
    
    private func checkUserSession() {
        if Auth.auth().currentUser == nil {
                let loginVC = LoginScreenVC()
                self.navigationController?.pushViewController(loginVC, animated: true)
        } else {
            let tabBarVC = TabBarController()
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    private func configureStackViewLoginData() {
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
        stackViewLoginData.setCustomSpacing(20, after: emailInput)
        
        stackViewLoginData.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackViewLoginData)
        
        NSLayoutConstraint.activate([
            stackViewLoginData.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            stackViewLoginData.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            stackViewLoginData.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 20),
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
        guard let username = userName.text, let email = emailInput.text, let password = passwordInput.text, let confirmPassword = confirmInput.text else { return }
        viewModel.loginButtonTapped(userName: username, email: email, password: password, confirmPassword: confirmPassword, isSignUp: isSignUp)
        
        self.isSignUp ? self.textFieldsShaker(inputFields: [userName, emailInput, passwordInput, confirmInput]) : self.textFieldsShaker(inputFields: [emailInput, passwordInput])
    }
}

extension LoginScreenVC: LoginScreenEvents {
    
    func onLoginSuccess() {
        self.showAlert(message: "Logged in!") {
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("User logged successfully")
    }
    
    func onLoginFailure(error: Error) {
        self.showAlert(message: error.localizedDescription, completion: nil)
    }
    
    func createUserSuccess() {
        self.showAlert(message: "Check your email with activation link!") {
            self.segmentedController.selectedSegmentIndex = 0
            self.isSignUp.toggle()
            self.userName.isHidden = true
            self.confirmInput.isHidden = true
        }
    }
    
    func createUserFailure(error: Error) {
        self.showAlert(message: error.localizedDescription, completion: nil)
    }
}

extension LoginScreenVC: UITextFieldDelegate {
    
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
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
}

