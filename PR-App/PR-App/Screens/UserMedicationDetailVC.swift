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
        configureStackView()
        configureDoseAndCapacityView()
        configureStackView2()
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
    
    private func configureStackView() {
        medicationView.addSubview(pillNameView)
        medicationView.addSubview(packageCapacityView)
        medicationView.addSubview(pillDoseView)
        
        
        let stackView = UIStackView(arrangedSubviews: [pillNameView, packageCapacityView, pillDoseView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        medicationView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: medicationView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: medicationButtonCamera.trailingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: medicationView.heightAnchor)
        ])
    }
    
    private func configureStackView2() {
        doseAndCapacityView.addSubview(dosageView)
        doseAndCapacityView.addSubview(doseProgramView)
        doseAndCapacityView.addSubview(capacityPillsLeft)
        
        let stackView2 = UIStackView(arrangedSubviews: [dosageView, doseProgramView, capacityPillsLeft])
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.axis = .vertical
        stackView2.distribution = .equalSpacing
        doseAndCapacityView.addSubview(stackView2)
        
        NSLayoutConstraint.activate([
            stackView2.topAnchor.constraint(equalTo: doseAndCapacityView.topAnchor),
            stackView2.leadingAnchor.constraint(equalTo: doseAndCapacityView.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: doseAndCapacityView.trailingAnchor),
            stackView2.bottomAnchor.constraint(equalTo: doseAndCapacityView.bottomAnchor)
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
        let vc = NewMedicationVC()
        present(vc, animated: true)
    }
}
