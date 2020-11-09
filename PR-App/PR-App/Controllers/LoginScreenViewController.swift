//
//  LoginScreenViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
// 

import UIKit
import FirebaseAuth

final class LoginScreenViewController: UIViewController {
    
    private let loginScreenView = LoginScreenView()
    private let welcomeView = WelcomeView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserSession()
        configureLoginScreenView()
        configureViewController()
        createDismisKeyboardTapGesture()
    }
    
    private func configureLoginScreenView() {
        loginScreenView.delegate = self
        loginScreenView.present = self
        loginScreenView.push = self
        
        view.addSubview(loginScreenView)
        
        loginScreenView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        
        welcomeView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
        navigationController?.isNavigationBarHidden = true
    }

    private func checkUserSession() {
        guard let user = Auth.auth().currentUser else { return }
        if Auth.auth().currentUser != nil && user.isEmailVerified {
            self.welcomeView.isHidden = true
            let tabBarVC = TabBarController()
            self.navigationController?.pushViewController(tabBarVC, animated: true)
            self.showUserAlert(message: Alerts.userSessionActive, withTime: .now() + 1.5, completion: nil)
        }
    }
}

extension LoginScreenViewController: LoginScreenPresentUserMedicationInfoVC {
    func userMedicationInfoViewController() {
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}

extension LoginScreenViewController: LoginScreenPresentForgotPasswordVC {
    func forgotPasswordViewController() {
        let forgotPasswordVC = UINavigationController(rootViewController: ForgotPasswordViewController())
        present(forgotPasswordVC, animated: true)
    }
}

extension LoginScreenViewController: LoginScreenAlertDelegate {
    func alertLoginSuccess(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        self.showUserAlert(message: message, withTime: nil, completion: completion)
    }
    
    func alertLoginFailure(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        self.showUserAlert(message: message, withTime: nil, completion: completion)
    }
    
    func alertCreateUserSuccess(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        self.showUserAlert(message: message, withTime: nil, completion: completion)
    }
    
    func alertCreateUserFailure(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        self.showUserAlert(message: message, withTime: nil, completion: completion)
    }
    
    func alertIsEmailVerified(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        self.showUserAlert(message: message, withTime: nil, completion: completion)
    }
}
