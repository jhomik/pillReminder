//
//  LoginScreenViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol LoginScreenEvents: AnyObject {
    func onLoginSuccess()
    func onLoginFailure(error: Error)
    func createUserSuccess()
    func createUserFailure(error: Error)
    func isEmailVerified()
}

final class LoginScreenViewModel {
    
    private let firebaseManager = FirebaseManager()
    private weak var loginEvents: LoginScreenEvents?
    
    init(loginEvents: LoginScreenEvents) {
        self.loginEvents = loginEvents
    }
    
    func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            return true
        } else {
            return false
        }
    }
    
    func signInUser(userName: String, email: String, password: String, confirmPassword: String, isSignUp: Bool = false) {
        firebaseManager.signInUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if !data {
                        self?.loginEvents?.isEmailVerified()
                    } else {
                        self?.loginEvents?.onLoginSuccess()
                    }
                case let .failure(error):
                    self?.loginEvents?.onLoginFailure(error: error)
                }
            }
        }
    }
    
    func createNewUser(userName: String, email: String, password: String, confirmPassword: String, isSignUp: Bool = false) {
        firebaseManager.createUser(username: userName, email: email, password: password, confirmPassword: confirmPassword, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loginEvents?.createUserSuccess()
                case .failure(let error):
                    self?.loginEvents?.createUserFailure(error: error)
                }
            }
        })
    }
    
    func loginButtonTapped(userName: String, email: String, password: String, confirmPassword: String, isSignUp: Bool = false) {
        if !isSignUp && !email.isEmpty && !password.isEmpty {
            signInUser(userName: userName, email: email, password: password, confirmPassword: confirmPassword)
            
        } else if isSignUp && !userName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && newPasswordCheck(passOne: password, passTwo: confirmPassword) == true {
            createNewUser(userName: userName, email: email, password: password, confirmPassword: confirmPassword)
        }
    }
}
