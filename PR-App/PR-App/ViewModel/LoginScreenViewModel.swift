//
//  LoginScreenViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class LoginScreenViewModel {
    
    var coordinator: MainCoordinator?
    var firebaseManager: FirebaseManager?
    var emailInput: String?
    var passwordInput: String?
    var confirmPassword: String?
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
    
   
    
    func loginButtonTapped() {
        
        guard let email = emailInput, let password = passwordInput, let confirmPassword = passwordInput else {
                 print("Form is not valid")
                 return
             }
             
             if !isSignUp && !email.isEmpty && !password.isEmpty {
                firebaseManager?.signInUser()
             } else if isSignUp && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
                firebaseManager?.createUser()
             } else {
                isSignUp ? textFieldsShaker(inputFields: [email, password, confirmPassword]) : textFieldsShaker(inputFields: [email, password])
             }
    }
}
 
