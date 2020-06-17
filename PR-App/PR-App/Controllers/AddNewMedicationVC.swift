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
    var pillNameView = PillNameView()
    var packageCapacityView = PackageCapacityView()
    var pillDoseView = PillDoseView()
    //    var medicationImage = CustomImagePill(frame: .zero)
    var medicationButtonCamera = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMedicationView()
        configureMedicationImage()
        configureStackView()
        view.backgroundColor = .systemGray
    }
    
    private func configureMedicationView() {
        
        view.addSubview(medicationView)
        medicationView.translatesAutoresizingMaskIntoConstraints = false
        medicationView.backgroundColor = .systemTeal
        
        NSLayoutConstraint.activate([
            medicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            medicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            medicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            medicationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureMedicationImage() {
        
        medicationView.addSubview(medicationButtonCamera)
        medicationButtonCamera.translatesAutoresizingMaskIntoConstraints = false
        medicationButtonCamera.backgroundColor = .systemRed
        medicationButtonCamera.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationButtonCamera.layer.cornerRadius = 16
        
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
        stackView.distribution = .fillProportionally
        medicationView.addSubview(stackView)
    
        pillNameView.backgroundColor = .systemOrange
        packageCapacityView.backgroundColor = .systemYellow
        pillDoseView.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: medicationView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: medicationButtonCamera.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: medicationView.heightAnchor)
        ])
    }
}
