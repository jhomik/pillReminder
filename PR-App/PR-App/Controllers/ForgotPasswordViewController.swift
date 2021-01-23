//
//  ForgotPasswordViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var viewModel = ForgotPasswordViewModel(firebaseManagerEvents: firebaseManager)
    lazy private(set) var forgotPasswordView = ForgotPasswordView(viewModel: viewModel)
    
    override func loadView() {
        self.view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        createDismisKeyboardTapGesture()
        viewModel.passwordEvents = self
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension ForgotPasswordViewController: ForgotPasswordEvents {
    func showSuccesAlert() {
        self.showUserAlert(message: Alerts.userForgotPassword, withTime: nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showFailureAlert(error: Error) {
        self.showUserAlert(message: error.localizedDescription, withTime: nil, completion: nil)
    }
}
