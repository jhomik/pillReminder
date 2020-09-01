//
//  PRErrors.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

enum PRErrors: String, Error {
    case userIsNotVerified = "Your email is not verified. Check your mail inbox for link to activate your account!"
    case failedToSignOut = "Failed to sign out, please try again."
    case cameraNotAvailable = "I'm sorry, camera is not available right now."
}
