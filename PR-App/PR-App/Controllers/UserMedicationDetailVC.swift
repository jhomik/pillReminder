//
//  AddNewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 22/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailVC: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let medicationView = UserMedicationDetailView()
    private let dosageMedicationView = DosageMedicationDetailView()
    private let editButton = CustomButton(text: Constants.changeSettings)
    var medications: UserMedicationDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureMedicationView()
        configureDoseAndCapacityView()
        configureEditButton()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func updateUI() {
        guard let meds = medications else { return }
        self.medicationView.updatePillNameValue(meds.pillName)
        self.medicationView.updatePackageCapacityValue(meds.capacity)
        self.medicationView.updatePillDoseValue(meds.dose)
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureMedicationView() {
        view.addSubview(medicationView)
        
        NSLayoutConstraint.activate([
            medicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            medicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            medicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            medicationView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configureDoseAndCapacityView() {
        view.addSubview(dosageMedicationView)
        
        NSLayoutConstraint.activate([
            dosageMedicationView.topAnchor.constraint(equalTo: medicationView.bottomAnchor, constant: 30),
            dosageMedicationView.leadingAnchor.constraint(equalTo: medicationView.leadingAnchor),
            dosageMedicationView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            dosageMedicationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureEditButton() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: dosageMedicationView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: dosageMedicationView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func editButtonTapped() {
        let newMedicationVC = NewMedicationVC()
        newMedicationVC.medicationsToChange = medications
        present(UINavigationController(rootViewController: newMedicationVC), animated: true)
    }
}
