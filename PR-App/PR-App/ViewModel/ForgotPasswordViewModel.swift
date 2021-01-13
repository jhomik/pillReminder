//
//  ForgotPasswordViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol ForgotPasswordEvents: AnyObject {
    func showSuccesAlert()
    func showFailureAlert(error: Error)
}

final class ForgotPasswordViewModel {
    
    private let firebaseManager = FirebaseManager()
    weak var forgotPasswordEvents: ForgotPasswordEvents?
    
    init(forgotPasswordEvents: ForgotPasswordEvents) {
        self.forgotPasswordEvents = forgotPasswordEvents
    }
    
    func resetUserPassword(withEmail: UserModel) {
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
