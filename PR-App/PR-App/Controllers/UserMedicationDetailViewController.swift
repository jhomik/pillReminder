//
//  UserMedicationDetailViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 22/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol DecreaseValueEventDelegate: AnyObject {
    func decreaseCapacity(with value: String?)
}

final class UserMedicationDetailViewController: UIViewController {
    
    private(set) var viewModel = UserMedicationDetailViewModel()
    lazy private(set) var userMedicationDetailView = UserMedicationDetailView(viewModel: viewModel)
    
    override func loadView() {
        self.view = userMedicationDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        viewModel.buttonTappedDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
    }
}

extension UserMedicationDetailViewController: PopViewControllerDelegate {
    func popViewController() {
        navigationController?.popViewController(animated: false)
    }
}

extension UserMedicationDetailViewController: EditButtonEventDelegate {
    func editButtonTapped() {
        let currentMedicationVC = CurrentMedicationSettingsViewController()
        currentMedicationVC.viewModel.medications = viewModel.medications
        currentMedicationVC.popViewDelegate = self
        present(UINavigationController(rootViewController: currentMedicationVC), animated: true)
    }
}
