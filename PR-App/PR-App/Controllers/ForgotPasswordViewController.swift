//
//  ForgotPasswordViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 25/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: UIViewController {
    
    private var forgotPasswordView = ForgotPasswordView()
    lazy var viewModel = ForgotPasswordViewModel(forgotPasswordEvents: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        configureForgotPasswordView()
        createDismisKeyboardTapGesture()
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
    
    private func configureForgotPasswordView() {
        let topAnchorConstant: CGFloat = 40
        
        forgotPasswordView.delegate = self
        view.addSubview(forgotPasswordView)
    
        forgotPasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(topAnchorConstant)
            make.leading.equalTo(topAnchorConstant)
            make.trailing.equalTo(-topAnchorConstant)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func resetPassword(withEmail: String) {
        viewModel.resetUserPassword(withEmail: withEmail)
    }
}
