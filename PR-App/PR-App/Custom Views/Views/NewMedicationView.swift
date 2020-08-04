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
    var nameTextField = CustomTextField(placeholderText: Constants.placeHolderNameMedication, isPassword: false)
    var capacityTextField = CustomTextField(placeholderText: Constants.placeHolderCapacityMedication, isPassword: false)
    var doseTextField = CustomTextField(placeholderText: Constants.placeHolderDoseMedication, isPassword: false)
    var newMedicationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
}
