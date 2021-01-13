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
    func isPasswordMatch()
}

final class LoginScreenViewModel {
    
    private let firebaseManager = FirebaseManager()
    weak var loginEvents: LoginScreenEvents?
    private(set) var isSignUp = false
    
    func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            return true
        } else {
            loginEvents?.isPasswordMatch()
            return false
        }
    }
    
    func toogleIsSignUp() {
        isSignUp.toggle()
    }
    
    func checkIfSignUp() -> Bool {
        if isSignUp {
            return false
        } else {
            return true
        }
    }
    
    func setTitleForButton() -> String {
        if isSignUp {
            return Constants.signUp
        } else {
            return Constants.signIn
        }
    }
    
    func signInUser(userModel: UserModel) {
        firebaseManager.signInUser(userModel: userModel, completion: { [weak self] result in
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
        })
    }
    
    func createNewUser(userModel: UserModel) {
        firebaseManager.createUser(userModel: userModel, completion: { [weak self] result in
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
    
    func loginButtonTapped(userModel: UserModel) {
        if !isSignUp && !userModel.signInEmpty {
            signInUser(userModel: userModel)
            
        } else if isSignUp && !userModel.signUpEmpty && newPasswordCheck(passOne: userModel.password, passTwo: userModel.confirmPassword) == true {
            createNewUser(userModel: userModel)
        }
    }
}
