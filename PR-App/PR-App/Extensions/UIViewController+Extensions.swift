//
//  UIViewController+EXT.swift
//  PR-App
//
//  Created by Jakub Homik on 19/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    
    func showLoadingSpinner(with containerView: UIView, spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            spinner.style = .large
            containerView.backgroundColor = .systemBackground
            containerView.alpha = 0
            
            UIView.animate(withDuration: 0.25) {
                containerView.alpha = 0.8
            }
            
            self.view.addSubview(containerView)
            containerView.addSubview(spinner)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            spinner.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])
            spinner.startAnimating()
        }
    }
    
    func dismissLoadingSpinner(with containerView: UIView, spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            spinner.stopAnimating()
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
    
    func textFieldShaker(_ textField: UITextField...) {
        textField.forEach { (field) in
            for field in textField {
                if let fieldText = field.text, fieldText.isEmpty {
                    field.shake()
                }
            }
        }
    }
}
