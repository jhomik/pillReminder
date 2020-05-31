//
//  AddNewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 22/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class UserMedicationDetailVC: UIViewController {
    
    var medicationView = UIView()
    var doseAndCapacityView = UIView()
    
    var pillNameView = PillNameView()
    var packageCapacityView = PackageCapacityView()
    var pillDoseView = PillDoseView()
    
    var dosageView = DosageView()
    var doseProgramView = DoseProgramView()
    var capacityPillsLeft = CapacityAndLeftPillsView()
    
    var medicationButtonCamera = UIButton()
    var editButton = CustomButton(text: "Change settings")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMedicationView()
        configureMedicationImage()
        pillStackView()
        configureDoseAndCapacityView()
        dosageStackView()
        configureEditButton()
        
        view.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureMedicationView() {
        view.addSubview(medicationView)
        medicationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            medicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            medicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            medicationView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configureDoseAndCapacityView() {
        view.addSubview(doseAndCapacityView)
        doseAndCapacityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doseAndCapacityView.topAnchor.constraint(equalTo: medicationView.bottomAnchor, constant: 30),
            doseAndCapacityView.leadingAnchor.constraint(equalTo: medicationView.leadingAnchor),
            doseAndCapacityView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            doseAndCapacityView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureMedicationImage() {
        medicationView.addSubview(medicationButtonCamera)
        
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        medicationButtonCamera.translatesAutoresizingMaskIntoConstraints = false
        medicationButtonCamera.backgroundColor = .systemGray5
        medicationButtonCamera.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationButtonCamera.setImage(UIImage(systemName: "camera", withConfiguration: settingsCellConfig), for: .normal)
        medicationButtonCamera.layer.cornerRadius = 16
        medicationButtonCamera.tintColor = .systemGray
        
        NSLayoutConstraint.activate([
            medicationButtonCamera.topAnchor.constraint(equalTo: medicationView.topAnchor),
            medicationButtonCamera.leadingAnchor.constraint(equalTo: medicationView.leadingAnchor),
            medicationButtonCamera.widthAnchor.constraint(equalTo: medicationView.widthAnchor, multiplier: 0.4),
            medicationButtonCamera.bottomAnchor.constraint(equalTo: medicationView.bottomAnchor)
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
        print("button tapped")
    }
    
    private func pillStackView() {
        medicationView.addSubview(pillNameView)
        medicationView.addSubview(packageCapacityView)
        medicationView.addSubview(pillDoseView)
        
        
        let pillStackView = UIStackView(arrangedSubviews: [pillNameView, packageCapacityView, pillDoseView])
        pillStackView.translatesAutoresizingMaskIntoConstraints = false
        pillStackView.axis = .vertical
        pillStackView.distribution = .equalSpacing
        medicationView.addSubview(pillStackView)
        
        NSLayoutConstraint.activate([
            pillStackView.topAnchor.constraint(equalTo: medicationView.topAnchor),
            pillStackView.leadingAnchor.constraint(equalTo: medicationButtonCamera.trailingAnchor, constant: 30),
            pillStackView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            pillStackView.heightAnchor.constraint(equalTo: medicationView.heightAnchor)
        ])
    }
    
    private func dosageStackView() {
        doseAndCapacityView.addSubview(dosageView)
        doseAndCapacityView.addSubview(doseProgramView)
        doseAndCapacityView.addSubview(capacityPillsLeft)
        
        let dosageStackView = UIStackView(arrangedSubviews: [dosageView, doseProgramView, capacityPillsLeft])
        dosageStackView.translatesAutoresizingMaskIntoConstraints = false
        dosageStackView.axis = .vertical
        dosageStackView.distribution = .equalSpacing
        doseAndCapacityView.addSubview(dosageStackView)
        
        NSLayoutConstraint.activate([
            dosageStackView.topAnchor.constraint(equalTo: doseAndCapacityView.topAnchor),
            dosageStackView.leadingAnchor.constraint(equalTo: doseAndCapacityView.leadingAnchor),
            dosageStackView.trailingAnchor.constraint(equalTo: doseAndCapacityView.trailingAnchor),
            dosageStackView.bottomAnchor.constraint(equalTo: doseAndCapacityView.bottomAnchor)
        ])
    }
    
    private func configureEditButton() {
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: doseAndCapacityView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: doseAndCapacityView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func editButtonTapped() {
        let newMedicationVC = UINavigationController(rootViewController: NewMedicationVC())
        present(newMedicationVC, animated: true)
    }
}
