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
    
    weak var firebaseManagerEvents: FirebaseManagerEvents?
    weak var loginEvents: LoginScreenEvents?
    
    private(set) var isSignUp = false
    
    init(firebaseManagerEvents: FirebaseManagerEvents) {
        self.firebaseManagerEvents = firebaseManagerEvents
    }
    
    func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            return true
        } else {
            loginEvents?.isPasswordMatch()
            return false
        }
    }
    
    func setHeightAnchorMulitplier() -> Float {
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard {
            return 0.42
        } else {
            return 0.34
        }
    }
    
    func setWidthAnchorMultiplier() -> Float {
        if DeviceTypes.isiPhoneSE {
            return 0.82
        } else {
            return 0.8
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
        firebaseManagerEvents?.signInUser(userModel: userModel, completion: { [weak self] result in
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
        firebaseManagerEvents?.createUser(userModel: userModel, completion: { [weak self] result in
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
