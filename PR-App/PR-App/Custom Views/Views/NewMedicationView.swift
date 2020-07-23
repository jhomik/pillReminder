//
//  NewMedicationView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class NewMedicationView: UIView {
    
    private let addMedicationLbl = CustomLabel(text: Constants.addMedication, alignment: .left, size: 24, weight: .bold, color: .label)
    private let nameTextField = CustomTextField(placeholderText: Constants.nameMedication, isPassword: false)
    private let capacityTextField = CustomTextField(placeholderText: Constants.packageMedication, isPassword: false)
    private let doseTextField = CustomTextField(placeholderText: Constants.doseMedication, isPassword: false)
    private let newMedicationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        configure()
        configureAddMedicationLbl()
        configureNewMedicationStackView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAddMedicationLbl() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addMedicationLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addMedicationLbl)
        
        NSLayoutConstraint.activate([
            addMedicationLbl.topAnchor.constraint(equalTo: self.topAnchor,constant: 12),
            addMedicationLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addMedicationLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addMedicationLbl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureNewMedicationStackView() {
        
        
        newMedicationStackView.addArrangedSubview(nameTextField)
        newMedicationStackView.addArrangedSubview(capacityTextField)
        newMedicationStackView.addArrangedSubview(doseTextField)
        newMedicationStackView.axis = .vertical
        newMedicationStackView.distribution = .equalSpacing
        newMedicationStackView.setCustomSpacing(20, after: nameTextField)
        
        newMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newMedicationStackView)
        
        NSLayoutConstraint.activate([
            newMedicationStackView.topAnchor.constraint(equalTo: addMedicationLbl.bottomAnchor, constant: 20),
            newMedicationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addMedicationLbl)
        self.addSubview(nameTextField)
        self.addSubview(capacityTextField)
        self.addSubview(doseTextField)
        
        
        NSLayoutConstraint.activate([
            addMedicationLbl.topAnchor.constraint(equalTo: self.topAnchor),
            addMedicationLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addMedicationLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addMedicationLbl.heightAnchor.constraint(equalToConstant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: addMedicationLbl.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            capacityTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            capacityTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            capacityTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            capacityTextField.heightAnchor.constraint(equalToConstant: 40),
            
            doseTextField.topAnchor.constraint(equalTo: capacityTextField.bottomAnchor, constant: 40),
            doseTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            doseTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            doseTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
