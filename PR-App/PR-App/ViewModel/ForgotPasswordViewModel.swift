//
//  ForgotPasswordViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol ForgotPasswordEvents: class {
    func showSuccesAlert()
    func showFailureAlert(error: Error)
}

final class ForgotPasswordViewModel {
    
    private let firebaseManager = FirebaseManager()
    private var forgotPasswordEvents: ForgotPasswordEvents?
    
    func resetUserPassword(withEmail: String) {
        firebaseManager.resetUserPassword(with: withEmail) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.forgotPasswordEvents?.showSuccesAlert()
            case .failure(let error):
                self.forgotPasswordEvents?.showFailureAlert(error: error)
            }
        }
    }
}
