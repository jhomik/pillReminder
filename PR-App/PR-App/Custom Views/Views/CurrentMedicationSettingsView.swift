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
    var medicationImageView = UIImageView()
    private let tapToChangeButton = UIButton()
    weak var delegate: UserMedicationDetailDelegate?
    private let firebaseManager = FirebaseManager()
    
    var medicationsToChange: UserMedicationDetailModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserMedicationSettingsView()
        configureAddMedicationLbl()
        configureMedicationImageView()
        configureTapToChangeImageButton()
        configureNewMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUserMedicationSettingsView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateUI() {
        guard let medication = medicationsToChange else { return }
        nameTextField.text = medication.pillName
        capacityTextField.text = medication.capacity
        doseTextField.text = medication.dose
        firebaseManager.downloadImage(with: medication.cellImage, imageCell: medicationImageView)
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
    
    private func configureMedicationImageView() {
        let medicationImageCornerRadius: CGFloat = 16
        let constraintConstat: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.35
        
        medicationImageView.backgroundColor = .secondarySystemFill
        medicationImageView.layer.cornerRadius = medicationImageCornerRadius
        medicationImageView.tintColor = .systemGray
        medicationImageView.layer.masksToBounds = true
        medicationImageView.isUserInteractionEnabled = true
        
        addSubview(medicationImageView)
        medicationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImageView.topAnchor.constraint(equalTo: changeMedication.bottomAnchor, constant: constraintConstat),
            medicationImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constraintConstat),
            medicationImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            medicationImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureTapToChangeImageButton() {
        let heightAnchorConstant: CGFloat = 25
        
        tapToChangeButton.addTarget(self, action: #selector(tapToChangeButtonTapped), for: .touchUpInside)
        tapToChangeButton.setTitle(Constants.tapToChange, for: .normal)
        tapToChangeButton.backgroundColor = UIColor.backgroundColorTapToChangeLabel
        tapToChangeButton.setTitleColor(.systemBackground, for: .normal)
        tapToChangeButton.layer.masksToBounds = true
        
        medicationImageView.addSubview(tapToChangeButton)
        tapToChangeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tapToChangeButton.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
            tapToChangeButton.leadingAnchor.constraint(equalTo: medicationImageView.leadingAnchor),
            tapToChangeButton.trailingAnchor.constraint(equalTo: medicationImageView.trailingAnchor),
            tapToChangeButton.bottomAnchor.constraint(equalTo: medicationImageView.bottomAnchor)
        ])
    }
    
    @objc private func tapToChangeButtonTapped() {
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
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationImageView.trailingAnchor, constant: constraintConstant),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
