//
//  UserMedicationDetailViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 22/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailViewController: UIViewController {
    
    var viewModel = UserMedicationDetailViewModel()
    private let medicationView = UserMedicationDetailView()
    private let dosageMedicationView = DosageMedicationDetailView()
    private let editButton = PillReminderMainCustomButton(text: Constants.changeSettings)
    var medications: UserMedicationDetailModel? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureViewController()
        configureMedicationView()
        configureDoseAndCapacityView()
        configureEditButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    
    }
        
    private func updateUI() {
        medicationView.medicationToChange = medications
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func configureMedicationView() {
        let constraintConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 180
        
        view.addSubview(medicationView)
        
        NSLayoutConstraint.activate([
            medicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constraintConstant),
            medicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant),
            medicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant),
            medicationView.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
        ])
    }
    
    private func configureDoseAndCapacityView() {
        let topAnchorConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 200
        
        view.addSubview(dosageMedicationView)
        
        NSLayoutConstraint.activate([
            dosageMedicationView.topAnchor.constraint(equalTo: medicationView.bottomAnchor, constant: topAnchorConstant),
            dosageMedicationView.leadingAnchor.constraint(equalTo: medicationView.leadingAnchor),
            dosageMedicationView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            dosageMedicationView.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
        ])
    }
    
    private func configureEditButton() {
        let bottomAnchorConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 40
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: dosageMedicationView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: dosageMedicationView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomAnchorConstant),
            editButton.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
        ])
    }
    
    @objc private func editButtonTapped() {
        let currentMedicationVC = CurrentMedicationSettingsViewController()
        currentMedicationVC.medications = medications
        present(UINavigationController(rootViewController: currentMedicationVC), animated: true)
    }
}
