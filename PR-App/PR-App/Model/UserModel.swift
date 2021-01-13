//
//  UserModel.swift
//  PillReminder
//
//  Created by Jakub Homik on 02/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import Foundation

struct UserModel {
    var userName: String
    var email: String
    var password: String
    var confirmPassword: String
    
    var signUpEmpty: Bool {
        return userName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty
    }
    
    var signInEmpty: Bool {
        return email.isEmpty || password.isEmpty
    }
    
    init(loginScreen: LoginScreenView?) {
        self.userName = loginScreen?.userNameTextField.text ?? ""
        self.email = loginScreen?.emailTextField.text ?? ""
        self.password = loginScreen?.passwordTextField.text ?? ""
        self.confirmPassword = loginScreen?.confirmTextField.text ?? ""
    }
}
