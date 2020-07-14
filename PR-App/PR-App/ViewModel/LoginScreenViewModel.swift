//
//  LoginScreenViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol LoginScreenEvents: class {
    func onLoginSuccess()
    func onLoginFailure(error: Error)
}

final class LoginScreenViewModel {
    
    private let firebaseManager = FirebaseManager()
    var isSignUp: Bool = false
    
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
    
    func textFieldsShaker(inputFields: [CustomTextField]) {
        for x in inputFields {
            if x.text!.isEmpty {
                x.shake()
            }
        }
    }
    
    func loginButtonTapped(email: String, password: String, confirmPassword: String) {
             if !isSignUp && !email.isEmpty && !password.isEmpty {
                firebaseManager.signInUser(email: email, password: password) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self?.loginEvents?.onLoginSuccess()
                        case let .failure(error):
                            self?.loginEvents?.onLoginFailure(error: error)
                        }
                    }
                }
             } else if isSignUp && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && newPasswordCheck(passOne: password, passTwo: confirmPassword) == true {
                firebaseManager.createUser(email: email, password: password, confirmPassword: confirmPassword)
             } else {
                print("error test")
//                isSignUp ? textFieldsShaker(inputFields: [email, password, confirmPassword]) : textFieldsShaker(inputFields: [email, password])
             }
    }
}
 
