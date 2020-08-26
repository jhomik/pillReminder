//
//  PRAlerts.swift
//  PR-App
//
//  Created by Jakub Homik on 26/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

enum PRAlerts: String, Error {
    case emailActivation = "Check your email with activation link!"
    case userLogIn = "Logged in!"
    case userSignOUt = "Are you sure you want to log out from account?"
    case userForgotPassword = "Your link with password reset has been sent!"
    case userSessionActive = "Welcome back!"
}


