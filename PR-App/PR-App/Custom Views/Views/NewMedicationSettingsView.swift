//
//  NewMedicationSettingsView.swift
//  PR-App
//
//  Created by Jakub Homik on 04/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationSettingsView: UIView {
    
    private(set) var addMedicationLbl = PillReminderMainCustomLabel(text: Constants.addMedication, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderNameMedication, isPassword: false)
    private(set) var capacityTextField = PillReminderMainCustomTextField(placeholderText:  Constants.placeHolderCapacityMedication, isPassword: false)
    private(set) var doseTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderDoseMedication, isPassword: false)
    private(set) var frequencyTextField = PillReminderProgramCustomTextFields(placeholderText: "Select frequency")
    private(set) var howManyTimesTextField = PillReminderProgramCustomTextFields(placeholderText: "How many times per day?")
    private(set) var whatTimeTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var dosageTextField = PillReminderProgramCustomTextFields(placeholderText: "Choose dosage")
    
    private(set) var frequencyLabel = PillReminderProgramCustomLabel(text: "Frequency")
    private(set) var howManyTimesLabel = PillReminderProgramCustomLabel(text: "How many times per day?")
    private(set) var whatTimeLabel = PillReminderProgramCustomLabel(text: "What time?")
    private(set) var dosageLabel = PillReminderProgramCustomLabel(text: "Dosage")
    
    private let pillModel = PillModel()
    private let newMedicationStackView = UIStackView()
    private let programMedicationStackView = UIStackView()
    private(set) var scrollView = UIScrollView()
    var medicationImageButton = UIButton()
    var medicationImage = UIImageView()
    weak var delegate: UserMedicationDetailDelegate?
    
    var medicationsToChange: UserMedicationDetailModel?
    
    var activeTextField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserMedicationSettingsView()
        configureScrollView()
        configureAddMedicationLbl()
        configureMedicationImageButton()
        configureMedicationImage()
        configureNewMedicationStackView()
        configureProgramMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUserMedicationSettingsView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureAddMedicationLbl() {
        let topAnchorConstant: CGFloat = 12
        let heightAnchorConstant: CGFloat = 30
        
        addMedicationLbl.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(addMedicationLbl)
        
        NSLayoutConstraint.activate([
            addMedicationLbl.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: topAnchorConstant),
            addMedicationLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addMedicationLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addMedicationLbl.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
        ])
    }
    
    private func configureMedicationImageButton() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let medicationImageButtonCornerRadius: CGFloat = 16
        let constraintConstat: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.42
        let heightAnchorMultiplier: CGFloat = 0.24
        
        medicationImageButton.backgroundColor = .systemGray5
        medicationImageButton.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationImageButton.setImage(UIImage(systemName: Images.cameraImage, withConfiguration: settingsCellConfig), for: .normal)
        medicationImageButton.layer.cornerRadius = medicationImageButtonCornerRadius
        medicationImageButton.tintColor = .systemGray
        medicationImageButton.layer.masksToBounds = true
        
        scrollView.addSubview(medicationImageButton)
        medicationImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImageButton.topAnchor.constraint(equalTo: addMedicationLbl.bottomAnchor, constant: constraintConstat),
            medicationImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constraintConstat),
            medicationImageButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            medicationImageButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: heightAnchorMultiplier)
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
        delegate?.imagePickerEvent()
    }
    
    private func configureMedicationImage() {
        let medicationImageCornerRadius: CGFloat = 16
        
        medicationImage.layer.masksToBounds = true
        medicationImage.layer.cornerRadius = medicationImageCornerRadius
        medicationImage.contentMode = .scaleToFill
        medicationImage.backgroundColor = UIColor.secondarySystemFill
        
        medicationImageButton.addSubview(medicationImage)
        medicationImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImage.topAnchor.constraint(equalTo: medicationImageButton.topAnchor),
            medicationImage.leadingAnchor.constraint(equalTo: medicationImageButton.leadingAnchor),
            medicationImage.widthAnchor.constraint(equalTo: medicationImageButton.widthAnchor),
            medicationImage.heightAnchor.constraint(equalTo: medicationImageButton.heightAnchor)
        ])
    }
    
    private func configureNewMedicationStackView() {
        let constraintConstant: CGFloat = 14
        
        newMedicationStackView.addArrangedSubview(nameTextField)
        newMedicationStackView.addArrangedSubview(capacityTextField)
        newMedicationStackView.addArrangedSubview(doseTextField)
        newMedicationStackView.axis = .vertical
        newMedicationStackView.distribution = .equalSpacing
        
        scrollView.addSubview(newMedicationStackView)
        newMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newMedicationStackView.topAnchor.constraint(equalTo: medicationImageButton.topAnchor, constant: constraintConstant),
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationImageButton.trailingAnchor, constant: constraintConstant),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: medicationImageButton.bottomAnchor, constant: -constraintConstant)
        ])
    }
    
    private func configureProgramMedicationStackView() {
        let constraintConstant: CGFloat = 20
        
        programMedicationStackView.addArrangedSubview(frequencyLabel)
        programMedicationStackView.addArrangedSubview(frequencyTextField)
        programMedicationStackView.addArrangedSubview(howManyTimesLabel)
        programMedicationStackView.addArrangedSubview(howManyTimesTextField)
        programMedicationStackView.addArrangedSubview(whatTimeLabel)
        programMedicationStackView.addArrangedSubview(whatTimeTextField)
        programMedicationStackView.addArrangedSubview(dosageLabel)
        programMedicationStackView.addArrangedSubview(dosageTextField)
        
        frequencyTextField.delegate = self
        howManyTimesTextField.delegate = self
        whatTimeTextField.delegate = self
        dosageTextField.delegate = self
        
        programMedicationStackView.axis = .vertical
        programMedicationStackView.distribution = .fillEqually
        
        scrollView.addSubview(programMedicationStackView)
        programMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            programMedicationStackView.topAnchor.constraint(equalTo: newMedicationStackView.bottomAnchor, constant: constraintConstant),
            programMedicationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            programMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            programMedicationStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func createPickerView(withTextField: UITextField, readUserDefault: String) {
        let pickerView = UIPickerView()
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let row = UserDefaults.standard.integer(forKey: readUserDefault)
        
        pickerView.delegate = self
        pickerView.selectRow(row, inComponent: 0, animated: false)
        withTextField.inputView = pickerView
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, doneButton], animated: false)
        withTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneButtonTapped() {
        self.endEditing(true)
    }
}

extension NewMedicationSettingsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == frequencyTextField {
            return pillModel.frequency.count
        } else if activeTextField == howManyTimesTextField {
            return pillModel.howManyTimesPerDay.count
        } else {
            return pillModel.dosage.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == frequencyTextField {
            activeTextField?.text = pillModel.frequency[row]
            return pillModel.frequency[row]
        } else if activeTextField == howManyTimesTextField {
            activeTextField?.text = pillModel.howManyTimesPerDay[row]
            return pillModel.howManyTimesPerDay[row]
        } else {
            activeTextField?.text = pillModel.dosage[row]
            return pillModel.dosage[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let activeTextField = activeTextField else { return }
        
        
        if activeTextField == frequencyTextField {
            UserDefaults.standard.set(row, forKey: "frequencyRow")
            activeTextField.text = pillModel.frequency[row]
        } else if activeTextField == howManyTimesTextField {
            UserDefaults.standard.set(row, forKey: "howManyTimesPerdDayRow")
            activeTextField.text = pillModel.howManyTimesPerDay[row]
        } else {
            UserDefaults.standard.set(row, forKey: "dosageRow")
            activeTextField.text = pillModel.dosage[row]
        }
    }
}

extension NewMedicationSettingsView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        activeTextField = textField
        
        if textField == frequencyTextField {
            createPickerView(withTextField: textField, readUserDefault: "frequencyRow")
        } else if textField == howManyTimesTextField {
            createPickerView(withTextField: textField, readUserDefault: "howManyTimesPerdDayRow")
        } else {
            createPickerView(withTextField: textField, readUserDefault: "dosageRow")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
