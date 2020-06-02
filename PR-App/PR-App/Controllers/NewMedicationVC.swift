//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationVC: UIViewController {
    
    private let newMedicationView = NewMedicationView()
    private let programMedicationView = ProgramMedicationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        configurePickerStackView()
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Constants.mainColor
    }
    
    @objc private func saveSettings() {
        print("saved")
    }
    
    private func configureMedicationView() {
        view.addSubview(newMedicationView)
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            newMedicationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
        ])
    }
    
    private func configurePickerStackView() {
        view.addSubview(programMedicationView)
        
        NSLayoutConstraint.activate([
            programMedicationView.topAnchor.constraint(equalTo: newMedicationView.bottomAnchor),
            programMedicationView.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            programMedicationView.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            programMedicationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
        ])
    }
}
