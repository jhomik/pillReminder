//
//  NewMedicationView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationView: UIView {
    
    private let addMedicationLbl = CustomLabel(text: Constants.addMedication, alignment: .left, size: 24, weight: .bold, color: .label)
    private let nameTextField = CustomMedicationTextField(placeholderText: Constants.nameMedication)
    private let capacityTextField = CustomMedicationTextField(placeholderText: Constants.packageMedication)
    private let doseTextField = CustomMedicationTextField(placeholderText: Constants.doseMedication)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
        
        self.addSubview(addMedicationLbl)
        self.addSubview(nameTextField)
        self.addSubview(capacityTextField)
        self.addSubview(doseTextField)
        
        
        NSLayoutConstraint.activate([
            addMedicationLbl.topAnchor.constraint(equalTo: self.topAnchor),
            addMedicationLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addMedicationLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addMedicationLbl.heightAnchor.constraint(equalToConstant: 40),
            
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
