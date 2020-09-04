//
//  CurrentMedicationSettingsView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol UserMedicationDetailDelegate: AnyObject {
    func imagePickerEvent()
}

final class CurrentMedicationSettingsView: UIView {
    
    private(set) var changeMedication = PillReminderMainCustomLabel(text: Constants.changeMedications, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderNameMedication, isPassword: false)
    private(set) var capacityTextField = PillReminderMainCustomTextField(placeholderText:  Constants.placeHolderCapacityMedication, isPassword: false)
    private(set) var doseTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderDoseMedication, isPassword: false)
    private var newMedicationStackView = UIStackView()
    var medicationImageButton = UIButton()
    var medicationImage = UIImageView()
    let tapToChangeImage = UILabel()
    weak var delegate: UserMedicationDetailDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserMedicationSettingsView()
        configureAddMedicationLbl()
        configureMedicationImageButton()
        configureMedicationImage()
        configureTapToChangeImageLabel()
        configureNewMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUserMedicationSettingsView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureAddMedicationLbl() {
        let topAnchorConstant: CGFloat = 12
        let heightAnchorConstant: CGFloat = 30
        
        changeMedication.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(changeMedication)
        
        NSLayoutConstraint.activate([
            changeMedication.topAnchor.constraint(equalTo: self.topAnchor,constant: topAnchorConstant),
            changeMedication.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            changeMedication.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            changeMedication.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
        ])
    }
    
    private func configureMedicationImageButton() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let medicationImageButtonCornerRadius: CGFloat = 16
        let constraintConstat: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.35
        
        medicationImageButton.backgroundColor = .systemGray5
        medicationImageButton.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationImageButton.setImage(UIImage(systemName: Images.cameraImage, withConfiguration: settingsCellConfig), for: .normal)
        medicationImageButton.layer.cornerRadius = medicationImageButtonCornerRadius
        medicationImageButton.tintColor = .systemGray
        medicationImageButton.layer.masksToBounds = true
        
        addSubview(medicationImageButton)
        medicationImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImageButton.topAnchor.constraint(equalTo: changeMedication.bottomAnchor, constant: constraintConstat),
            medicationImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constraintConstat),
            medicationImageButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            medicationImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureMedicationImage() {
        let medicationImageCornerRadius: CGFloat = 16
        
        medicationImage.layer.masksToBounds = true
        medicationImage.layer.cornerRadius = medicationImageCornerRadius
        medicationImage.contentMode = .scaleToFill
        
        medicationImageButton.addSubview(medicationImage)
        medicationImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImage.topAnchor.constraint(equalTo: medicationImageButton.topAnchor),
            medicationImage.leadingAnchor.constraint(equalTo: medicationImageButton.leadingAnchor),
            medicationImage.widthAnchor.constraint(equalTo: medicationImageButton.widthAnchor),
            medicationImage.bottomAnchor.constraint(equalTo: medicationImageButton.bottomAnchor)
        ])
    }
    
    private func configureTapToChangeImageLabel() {
        let heightAnchorConstant: CGFloat = 30
        
        tapToChangeImage.text = Constants.tapToChange
        tapToChangeImage.backgroundColor = UIColor.backgroundColorTapToChangeLabel
        tapToChangeImage.textColor = .systemBackground
        tapToChangeImage.textAlignment = .center
        tapToChangeImage.layer.masksToBounds = true
        
        medicationImageButton.addSubview(tapToChangeImage)
        tapToChangeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tapToChangeImage.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
            tapToChangeImage.leadingAnchor.constraint(equalTo: medicationImageButton.leadingAnchor),
            tapToChangeImage.trailingAnchor.constraint(equalTo: medicationImageButton.trailingAnchor),
            tapToChangeImage.bottomAnchor.constraint(equalTo: medicationImageButton.bottomAnchor)
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
        delegate?.imagePickerEvent()
    }
    
    private func configureNewMedicationStackView() {
        let constraintConstant: CGFloat = 20
        
        newMedicationStackView.addArrangedSubview(nameTextField)
        newMedicationStackView.addArrangedSubview(capacityTextField)
        newMedicationStackView.addArrangedSubview(doseTextField)
        newMedicationStackView.axis = .vertical
        newMedicationStackView.distribution = .equalSpacing
        newMedicationStackView.setCustomSpacing(constraintConstant, after: nameTextField)
        
        newMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newMedicationStackView)
        
        NSLayoutConstraint.activate([
            newMedicationStackView.topAnchor.constraint(equalTo: changeMedication.bottomAnchor, constant: constraintConstant),
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationImageButton.trailingAnchor, constant: constraintConstant),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
