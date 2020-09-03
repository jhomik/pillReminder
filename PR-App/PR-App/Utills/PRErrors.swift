//
//  PRErrors.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

enum Errors: String, Error {
    case userIsNotVerified = NSLocalizedString("userIsNotVerified", comment: "")
    case failedToSignOut = NSLocalizedString("failedToSignOut", comment: "")
    case cameraNotAvailable = NSLocalizedString("cameraNotAvailable", comment: "")
}
