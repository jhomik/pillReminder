//
//  UIViewController+EXT.swift
//  PR-App
//
//  Created by Jakub Homik on 19/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showLoadingSpinner(with containerView: UIView) {
        containerView.frame = view.bounds
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        view.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingSpinner(with containerView: UIView) {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
        }
    }
    
    func showUserAlert(message: String, withTime: DispatchTime?, completion: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: withTime ?? .now() + 3) {
            alert.dismiss(animated: true, completion: completion)
        }
    }
    
    func showUserAlertWithOptions(title: String?, message: String?, actionTitle: String?, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { _ in
            completion?()
        }))
        alert.addAction(UIAlertAction(title: Alerts.cancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func createDismisKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldsShaker(inputFields: [PillReminderMainCustomTextField]) {
        for field in inputFields {
            if let fieldText = field.text, fieldText.isEmpty {
                field.shake()
            }
        }
    }
    
    func textFieldsShaker2(inputFields: [PillReminderProgramCustomTextFields]) {
        for field in inputFields {
            if let fieldText = field.text, fieldText.isEmpty {
                field.shake()
            }
        }
    }
}
