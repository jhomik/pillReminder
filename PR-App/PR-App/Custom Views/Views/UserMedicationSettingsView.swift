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
    var medicationButton = UIButton()
    var pillImage = UIImageView()
    var delegate: UserMedicationDetailDelegate?
    let tapToChange = UILabel()
    
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
            addMedicationLbl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureMedicationButtonCamera() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        medicationButton.backgroundColor = .systemGray5
        medicationButton.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationButton.setImage(UIImage(systemName: "camera", withConfiguration: settingsCellConfig), for: .normal)
        medicationButton.layer.cornerRadius = 16
        medicationButton.tintColor = .systemGray
        medicationButton.layer.masksToBounds = true
        
        tapToChange.text = Constants.tapToChange
        tapToChange.backgroundColor = UIColor(white: 0, alpha: 0.7)
        tapToChange.textColor = .systemBackground
        tapToChange.textAlignment = .center
        tapToChange.layer.masksToBounds = true
        
        pillImage.layer.masksToBounds = true
        pillImage.layer.cornerRadius = 16
        pillImage.contentMode = .scaleToFill
        
        
        addSubview(medicationButton)
        medicationButton.addSubview(pillImage)
        medicationButton.addSubview(tapToChange)
        pillImage.translatesAutoresizingMaskIntoConstraints = false
        medicationButton.translatesAutoresizingMaskIntoConstraints = false
        tapToChange.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationButton.topAnchor.constraint(equalTo: addMedicationLbl.bottomAnchor, constant: 20),
            medicationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            medicationButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            medicationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tapToChange.heightAnchor.constraint(equalToConstant: 30),
            tapToChange.leadingAnchor.constraint(equalTo: medicationButton.leadingAnchor),
            tapToChange.trailingAnchor.constraint(equalTo: medicationButton.trailingAnchor),
            tapToChange.bottomAnchor.constraint(equalTo: medicationButton.bottomAnchor),
            
            pillImage.topAnchor.constraint(equalTo: medicationButton.topAnchor),
            pillImage.leadingAnchor.constraint(equalTo: medicationButton.leadingAnchor),
            pillImage.widthAnchor.constraint(equalTo: medicationButton.widthAnchor),
            pillImage.bottomAnchor.constraint(equalTo: medicationButton.bottomAnchor),
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
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationButton.trailingAnchor, constant: 20),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
