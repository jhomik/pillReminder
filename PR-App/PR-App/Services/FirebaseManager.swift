//
//  FirebaseManager.swift
//  PR-App
//
//  Created by Jakub Homik on 10/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseManager: UIViewController {
    
    var emailInput: String = ""
    var passwordInput: String = ""
    var coordinator: MainCoordinator?
    
    func signInUser() {
           guard !emailInput.isEmpty, !passwordInput.isEmpty else {
               print("Form is not valid")
               return
           }
           
           Auth.auth().signIn(withEmail: emailInput, password: passwordInput) { (data, error) in
               
               if let error = error {
                   print(error.localizedDescription)
               } else {
                   self.showAlert(message: "Logged In!") {
                    self.coordinator?.showUserMedicationInfo()
                   }
                   print("success!")
               }
           }
       }
       
       func createUser() {
           guard let email = emailInput.text, let password = passwordInput.text, let confirmPassword = passwordInput.text else {
               print("Form is not valid")
               return
           }
           
           if viewModel.newPasswordCheck(passOne: password, passTwo: confirmPassword) {
               Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                   
                   if error != nil {
                       print("error popup here")
                   } else {
                       self.showAlert(message: "Check your email with activation link!") {
                       }
                       print("success")
                   }
               }
           } else {
               print("passwords don't match")
           }
       }
}
