//
//  NewMedicationView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol UserMedicationDetailDelegate {
    func imagePickerEvent()
}

class UserMedicationSettingsView: UIView {
    
    private(set) var addMedicationLbl = CustomLabel(text: Constants.addMedication, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = CustomTextField(placeholderText: Constants.placeHolderNameMedication, isPassword: false)
    private(set) var capacityTextField = CustomTextField(placeholderText: Constants.placeHolderCapacityMedication, isPassword: false)
    private(set) var doseTextField = CustomTextField(placeholderText: Constants.placeHolderDoseMedication, isPassword: false)
    var newMedicationStackView = UIStackView()
    var medicationImage = UIButton()
    var pillImage = UIImageView()
    var delegate: UserMedicationDetailDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAddMedicationLbl()
        configureMedicationButtonCamera()
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
    
    private func configureMedicationButtonCamera() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        medicationImage.backgroundColor = .systemGray5
        medicationImage.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationImage.setImage(UIImage(systemName: "camera", withConfiguration: settingsCellConfig), for: .normal)
        medicationImage.layer.cornerRadius = 16
        medicationImage.tintColor = .systemGray
        pillImage.layer.masksToBounds = true
        pillImage.layer.cornerRadius = 16
        
        addSubview(medicationImage)
        medicationImage.addSubview(pillImage)
        pillImage.translatesAutoresizingMaskIntoConstraints = false
        medicationImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImage.topAnchor.constraint(equalTo: addMedicationLbl.bottomAnchor, constant: 20),
            medicationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            medicationImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            medicationImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            pillImage.topAnchor.constraint(equalTo: medicationImage.topAnchor),
            pillImage.leadingAnchor.constraint(equalTo: medicationImage.leadingAnchor),
            pillImage.widthAnchor.constraint(equalTo: medicationImage.widthAnchor),
            pillImage.bottomAnchor.constraint(equalTo: medicationImage.bottomAnchor),
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
           delegate?.imagePickerEvent()
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
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationImage.trailingAnchor, constant: 20),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
