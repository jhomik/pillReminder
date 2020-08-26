//
//  ForgotPasswordVC.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    private var forgotPasswordView = ForgotPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        configureForgotPasswordView()
        createDismisKeyboardTapGesture()
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.tintColor = Constants.mainColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureForgotPasswordView() {
        view.addSubview(forgotPasswordView)
        forgotPasswordView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            forgotPasswordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            forgotPasswordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            forgotPasswordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            forgotPasswordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ForgotPasswordVC: ForgotPasswordEvents {
    func showSuccesAlert() {
        self.showUserAlert(message: "Your link with password reset has been sent!") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showFailureAlert(error: Error) {
        self.showUserAlert(message: error.localizedDescription, completion: nil)
    }
}
