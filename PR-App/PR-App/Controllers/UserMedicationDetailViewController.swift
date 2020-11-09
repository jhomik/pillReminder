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
           updateUI()
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
        
        medicationView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(constraintConstant)
            make.leading.equalTo(constraintConstant)
            make.trailing.equalTo(-constraintConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureDoseAndCapacityView() {
        let topAnchorConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 200
        
        view.addSubview(dosageMedicationView)
        
        dosageMedicationView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(medicationView)
            make.top.equalTo(medicationView.snp.bottom).offset(topAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureEditButton() {
        let bottomAnchorConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 40
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        view.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(dosageMedicationView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-bottomAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc private func editButtonTapped() {
        let currentMedicationVC = CurrentMedicationSettingsViewController()
        currentMedicationVC.medications = medications
        currentMedicationVC.delegate = self
        present(UINavigationController(rootViewController: currentMedicationVC), animated: true)
    }
}

extension UserMedicationDetailViewController: PassMedicationDelegate {
    func passMedication(medication: UserMedicationDetailModel) {
        medicationView.medicationToChange = medication
    }
}
