//
//  UserMedicationInfoViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseAuth

final class UserMedicationInfoViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let containerView = UIView()
    private let spinner = UIActivityIndicatorView()
    
    lazy private(set) var viewModel = UserMedicationInfoViewModel(firebaseManagerEvents: firebaseManager)
    lazy private(set) var userMedicationInfoView = UserMedicationInfoView(viewModel: viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        viewModel.delegateMedicationInfo = self
    }
    
    override func loadView() {
        self.view = userMedicationInfoView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.signOut, style: .plain, target: self, action: #selector(logoutSession))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.back, style: .plain, target: self, action: nil)
        
        viewModel.setUserName(completion: { (userName) in
            self.navigationItem.title = Constants.hello + userName + "!"
        })
    }
    
    @objc private func logoutSession() {
        showUserAlertWithOptions(title: nil, message: Alerts.userSignOUt, actionTitle: Constants.signOut) {
            self.signOutUser()
        }
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            self.tabBarController?.navigationController?.popViewController(animated: true)
        } catch let error {
            self.showUserAlert(message: Errors.failedToSignOut + ":\(error)", withTime: nil, completion: nil)
        }
    }
    
    private func changeBarButtonItem() {
        let barButtonItem: UIBarButtonItem.SystemItem = viewModel.isActiveEditButton ? .cancel : .edit
        let button = UIBarButtonItem(barButtonSystemItem: barButtonItem, target: self, action: #selector(deleteMedication))
        button.isEnabled = viewModel.medications.count > 0 || viewModel.isActiveEditButton
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func deleteMedication() {
        viewModel.toggleEditButton()
    }
}

extension UserMedicationInfoViewController: UserMedicationInfoEventDelegate {
    
    func isInteractionEnabled(_ enabled: Bool) {
        if enabled {
            userMedicationInfoView.isUserInteractionEnabled = false
        } else {
            userMedicationInfoView.isUserInteractionEnabled = true
        }
    }
    
    func isLoading(_ loading: Bool) {
        if loading {
            showLoadingSpinner(with: containerView, spinner: spinner)
        } else {
            dismissLoadingSpinner(with: containerView, spinner: spinner)
        }
    }
    
    func pushNewMedicationSettingsController() {
        let newMedicationSettings = NewMedicationSettingsViewController()
        present(UINavigationController(rootViewController: newMedicationSettings), animated: true, completion: nil)
    }
    
    func pushUserMedicationDetailController(with medications: UserMedicationDetailModel) {
        let userMedicationDetail = UserMedicationDetailViewController()
        userMedicationDetail.viewModel.medications = medications
        self.navigationController?.pushViewController(userMedicationDetail, animated: true)
    }
    
    func updateBarButtonItem() {
        changeBarButtonItem()
    }
}
