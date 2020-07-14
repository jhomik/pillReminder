//
//  LoginScreenViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class LoginScreenViewModel {
    
    weak var coordinator: MainCoordinator?
    private let firebaseManager = FirebaseManager()
    var isSignUp: Bool = false
    
    func newPasswordCheck(passOne: String, passTwo: String) -> Bool {
        if passOne == passTwo {
            return true
        } else {
            return false
        }
    }
    
    func tappedOnMedication() {
        coordinator?.showUserMedicationDetail()
        print("test")
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
                firebaseManager.signInUser(email: email, password: password) {
                    self.coordinator?.showUserMedicationInfo()
                }
             } else if isSignUp && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && newPasswordCheck(passOne: password, passTwo: confirmPassword) == true {
                firebaseManager.createUser(email: email, password: password, confirmPassword: confirmPassword)
             } else {
                print("error test")
//                isSignUp ? textFieldsShaker(inputFields: [email, password, confirmPassword]) : textFieldsShaker(inputFields: [email, password])
             }
    }
}
 
