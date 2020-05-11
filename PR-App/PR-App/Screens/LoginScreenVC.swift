//
//  LoginScreenVC.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginScreenVC: UIViewController {
    
    let welcomeView = UIView()
    let welcomeImage = UIImageView()
    
    var scrollView      : UIScrollView!
    var usernameInput   = CustomInputField(placeholderText: "Email Address", isPassword: false)
    var passwordInput   = CustomInputField(placeholderText: "Password", isPassword: true)
    var confirmInput    = CustomInputField(placeholderText: "Confirm Password", isPassword: true)
    var button          : CustomButton!
    var logoImage       = UIImageView(image: Constants.logoImage)
    var toggleLabel     = UILabel()
    var isSignUp        = false
    var segmentedController : UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
        performAnimations()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureScrollView()
        configure()
        configureLogoImage()
        configureSegmentedView()
        configureUsernameInputField()
        configurePasswordInputField()
        configureConfirmInputField()
        dismissKeyboard()
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        welcomeView.frame = view.bounds
        welcomeView.backgroundColor = .systemBackground
        
        welcomeView.addSubview(welcomeImage)
        welcomeImage.translatesAutoresizingMaskIntoConstraints = false
        welcomeImage.image = UIImage(named: "logo-PR")
        
        NSLayoutConstraint.activate([
            welcomeImage.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor),
            welcomeImage.centerYAnchor.constraint(equalTo: welcomeView.centerYAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: 200),
            welcomeImage.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func performAnimations() {

            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
                self.welcomeImage.alpha = 0.0
            }) { (finished) in
                UIView.transition(with: self.welcomeView, duration: 2, options: .transitionCrossDissolve, animations: {
                    self.welcomeView.alpha = 0.0
                }, completion: nil)
            }
        }
    
    
    private func configure() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureScrollView() {
        scrollView                                              = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        scrollView.isScrollEnabled                              = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: button.topAnchor)
        ])
    }
    private func configureSegmentedView() {
        segmentedController                                             = UISegmentedControl(items: ["Sign In", "Create Account"])
        segmentedController.apportionsSegmentWidthsByContent            = false
        segmentedController.selectedSegmentTintColor                    = Constants.mainColor
        segmentedController.translatesAutoresizingMaskIntoConstraints   = false
        segmentedController.selectedSegmentIndex                        = 0
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
        confirmInput.isHidden                      = !self.isSignUp
        toggleLabel.text                           = self.isSignUp ? "Current User?" : "New User?"
        usernameInput.text?                        = ""
        passwordInput.text?                        = ""
        confirmInput.text?                         = ""
        isSignUp ? (self.passwordInput.placeholder = "Create Password") : (self.passwordInput.placeholder = "Password")
        isSignUp ? self.button.setTitle("Sign Up", for: .normal) : self.button.setTitle("Log In", for: .normal)
        
    }
    
    private func configureLogoImage() {
        let horizontalConstant  = UIScreen.main.bounds.width / 10
        let widthConstant       = UIScreen.main.bounds.width * 0.8
        let heightConstant      = widthConstant * 0.9239
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: heightConstant),
            logoImage.widthAnchor.constraint(equalToConstant: widthConstant),
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: horizontalConstant),
            logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            
        ])
    }
    
    
    private func configureUsernameInputField() {
        usernameInput.delegate = self
        scrollView.addSubview(usernameInput)
        NSLayoutConstraint.activate([
            usernameInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            usernameInput.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            usernameInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            usernameInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordInputField() {
        passwordInput.delegate = self
        scrollView.addSubview(passwordInput)
        NSLayoutConstraint.activate([
            passwordInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            passwordInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: 20),
            passwordInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            passwordInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        
        button = CustomButton(text: "Log In")
        button.addTarget(self, action: #selector(bestButtonPress), for: .touchUpInside)
        view.addSubview(button)
        let horizontalConstant  = UIScreen.main.bounds.width / 10
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalConstant),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalConstant),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureConfirmInputField() {
        confirmInput.delegate = self
        scrollView.addSubview(confirmInput)
        NSLayoutConstraint.activate([
            confirmInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            confirmInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 20),
            confirmInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            confirmInput.heightAnchor.constraint(equalToConstant: 50)
        ])
        confirmInput.isHidden = true
    }
    
    @objc private func bestButtonPress() {
        if !isSignUp && !usernameInput.text!.isEmpty && !passwordInput.text!.isEmpty {
            Auth.auth().signIn(withEmail: usernameInput.text!, password: passwordInput.text!) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("success!")
                }
            }
        } else if isSignUp && !usernameInput.text!.isEmpty && !passwordInput.text!.isEmpty && !confirmInput.text!.isEmpty {
            if newPasswordCheck(passOne: passwordInput.text!, passTwo: confirmInput.text!) {
                Auth.auth().createUser(withEmail: usernameInput.text!, password: passwordInput.text!) { (data, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        print("error popup here")
                    } else {
                        print("success")
                    }
                }
            } else {
                print("passwords don't match")
            }
        } else {
            isSignUp ? textFieldsShaker(inputFields: [usernameInput, passwordInput, confirmInput]) : textFieldsShaker(inputFields: [usernameInput, passwordInput])
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
    private func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            //any other password verification here
            return true
        } else {
            return false
        }
    }
    
    private func textFieldsShaker(inputFields: [CustomInputField]) {
        for x in inputFields {
            if x.text!.isEmpty {
                x.shake()
            }
        }
    }
    
    
}

extension LoginScreenVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameInput {
            passwordInput.becomeFirstResponder()
        } else if textField == passwordInput {
            if isSignUp {
                confirmInput.becomeFirstResponder()
            } else {
                passwordInput.resignFirstResponder()
                bestButtonPress()
            }
        }
    }
        
    
    private func configure() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureScrollView() {
        scrollView                                              = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        scrollView.isScrollEnabled                              = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: button.topAnchor)
        ])
    }
    private func configureSegmentedView() {
        segmentedController                                             = UISegmentedControl(items: ["Sign In", "Create Account"])
        segmentedController.apportionsSegmentWidthsByContent            = false
        segmentedController.selectedSegmentTintColor                    = Constants.mainColor
        segmentedController.translatesAutoresizingMaskIntoConstraints   = false
        segmentedController.selectedSegmentIndex                        = 0
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
        confirmInput.isHidden                      = !self.isSignUp
        toggleLabel.text                           = self.isSignUp ? "Current User?" : "New User?"
        usernameInput.text?                        = ""
        passwordInput.text?                        = ""
        confirmInput.text?                         = ""
        isSignUp ? (self.passwordInput.placeholder = "Create Password") : (self.passwordInput.placeholder = "Password")
        isSignUp ? self.button.setTitle("Sign Up", for: .normal) : self.button.setTitle("Log In", for: .normal)
        
    }

    private func configureLogoImage() {
        let horizontalConstant  = UIScreen.main.bounds.width / 10
        let widthConstant       = UIScreen.main.bounds.width * 0.8
        let heightConstant      = widthConstant * 0.9239
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: heightConstant),
            logoImage.widthAnchor.constraint(equalToConstant: widthConstant),
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: horizontalConstant),
            logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            
        ])
    }
    
    
    private func configureUsernameInputField() {
        usernameInput.delegate = self
        scrollView.addSubview(usernameInput)
        NSLayoutConstraint.activate([
            usernameInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            usernameInput.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            usernameInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            usernameInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordInputField() {
        passwordInput.delegate = self
        scrollView.addSubview(passwordInput)
        NSLayoutConstraint.activate([
            passwordInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            passwordInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor, constant: 20),
            passwordInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            passwordInput.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        
        button = CustomButton(text: "Log In")
        button.addTarget(self, action: #selector(bestButtonPress), for: .touchUpInside)
        view.addSubview(button)
        let horizontalConstant  = UIScreen.main.bounds.width / 10
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalConstant),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalConstant),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureConfirmInputField() {
        confirmInput.delegate = self
        scrollView.addSubview(confirmInput)
        NSLayoutConstraint.activate([
            confirmInput.leadingAnchor.constraint(equalTo: segmentedController.leadingAnchor),
            confirmInput.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 20),
            confirmInput.trailingAnchor.constraint(equalTo: segmentedController.trailingAnchor),
            confirmInput.heightAnchor.constraint(equalToConstant: 50)
        ])
        confirmInput.isHidden = true
    }
    
    @objc private func bestButtonPress() {
        if !isSignUp && !usernameInput.text!.isEmpty && !passwordInput.text!.isEmpty {
            Auth.auth().signIn(withEmail: usernameInput.text!, password: passwordInput.text!) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("success!")
                }
            }
        } else if isSignUp && !usernameInput.text!.isEmpty && !passwordInput.text!.isEmpty && !confirmInput.text!.isEmpty {
            if newPasswordCheck(passOne: passwordInput.text!, passTwo: confirmInput.text!) {
                Auth.auth().createUser(withEmail: usernameInput.text!, password: passwordInput.text!) { (data, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        print("error popup here")
                    } else {
                        print("success")
                    }
                }
            } else {
                print("passwords don't match")
            }
        } else {
            isSignUp ? textFieldsShaker(inputFields: [usernameInput, passwordInput, confirmInput]) : textFieldsShaker(inputFields: [usernameInput, passwordInput])
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
    private func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            //any other password verification here
            return true
        } else {
            return false
        }
    }
    
    private func textFieldsShaker(inputFields: [CustomInputField]) {
        for x in inputFields {
            if x.text!.isEmpty {
                x.shake()
            }
        }
    }
    

}

extension LoginScreenVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameInput {
            passwordInput.becomeFirstResponder()
        } else if textField == passwordInput {
            if isSignUp {
                confirmInput.becomeFirstResponder()
            } else {
                passwordInput.resignFirstResponder()
                bestButtonPress()
            }
        } else {
            confirmInput.resignFirstResponder()
            bestButtonPress()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
