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
    
    private(set) var changeMedicationLbl = PillReminderMainCustomLabel(text: Constants.changeMedications, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderNameMedication, isPassword: false)
    private(set) var capacityTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderCapacityMedication, isPassword: false)
    private(set) var doseTextField = PillReminderMainCustomTextField(placeholderText: Constants.placeHolderDoseMedication, isPassword: false)
    
    private(set) var frequencyTextField = PillReminderProgramCustomTextFields(placeholderText: "Select frequency")
    private(set) var howManyTimesTextField = PillReminderProgramCustomTextFields(placeholderText: "How many times per day?")
    private(set) var whatTimeOnceADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var whatTimeTwiceADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var whatTimeThreeTimesADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var dosageTextField = PillReminderProgramCustomTextFields(placeholderText: "Choose dosage")
    
    private(set) var frequencyLabel = PillReminderProgramCustomLabel(text: "Frequency")
    private(set) var howManyTimesLabel = PillReminderProgramCustomLabel(text: "How many times per day?")
    private(set) var whatTimeLabel = PillReminderProgramCustomLabel(text: "What time?")
    private(set) var dosageLabel = PillReminderProgramCustomLabel(text: "Dosage")
    
    private var currentMedicationStackView = UIStackView()
    private let programMedicationStackView = UIStackView()
    var medicationImageView = UIImageView()
    private let tapToChangeButton = UIButton()
    private(set) var scrollView = UIScrollView()
    weak var delegate: UserMedicationDetailDelegate?
    private let firebaseManager = FirebaseManager()
    var activeTextField: UITextField?
    private var pillModel = PillModel()
    
    var medicationsToChange: UserMedicationDetailModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserMedicationSettingsView()
        configureScrollView()
        configureChangeMedication()
        configureMedicationImageView()
        configureTapToChangeImageButton()
        configureCurrentMedicationStackView()
        configureProgramMedicationStackView()
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
        frequencyTextField.text = medication.frequency
        howManyTimesTextField.text = medication.howManyTimesPerDay
        dosageTextField.text = medication.dosage
        firebaseManager.downloadImage(with: medication.cellImage ?? "", imageCell: medicationImageView)
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
    
    private func configureChangeMedication() {
        let topAnchorConstant: CGFloat = 12
        let heightAnchorConstant: CGFloat = 30
        
        changeMedicationLbl.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(changeMedicationLbl)
        
        NSLayoutConstraint.activate([
            changeMedicationLbl.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topAnchorConstant),
            changeMedicationLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            changeMedicationLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            changeMedicationLbl.heightAnchor.constraint(equalToConstant: heightAnchorConstant)
        ])
    }
    
    private func configureMedicationImageView() {
        let medicationImageCornerRadius: CGFloat = 16
        let constraintConstat: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.42
        let heightAnchorMultiplier: CGFloat = 0.24
        
        medicationImageView.backgroundColor = .secondarySystemFill
        medicationImageView.layer.cornerRadius = medicationImageCornerRadius
        medicationImageView.tintColor = .systemGray
        medicationImageView.layer.masksToBounds = true
        medicationImageView.isUserInteractionEnabled = true
        
        scrollView.addSubview(medicationImageView)
        medicationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationImageView.topAnchor.constraint(equalTo: changeMedicationLbl.bottomAnchor, constant: constraintConstat),
            medicationImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constraintConstat),
            medicationImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            medicationImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: heightAnchorMultiplier)
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
    
    private func configureCurrentMedicationStackView() {
        let constraintConstant: CGFloat = 14
        
        currentMedicationStackView.addArrangedSubview(nameTextField)
        currentMedicationStackView.addArrangedSubview(capacityTextField)
        currentMedicationStackView.addArrangedSubview(doseTextField)
        currentMedicationStackView.axis = .vertical
        currentMedicationStackView.distribution = .equalSpacing
        currentMedicationStackView.setCustomSpacing(constraintConstant, after: nameTextField)
        
        currentMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(currentMedicationStackView)
        
        NSLayoutConstraint.activate([
            currentMedicationStackView.topAnchor.constraint(equalTo: medicationImageView.topAnchor, constant: constraintConstant),
            currentMedicationStackView.leadingAnchor.constraint(equalTo: medicationImageView.trailingAnchor, constant: constraintConstant),
            currentMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            currentMedicationStackView.bottomAnchor.constraint(equalTo: medicationImageView.bottomAnchor, constant: -constraintConstant)
        ])
    }
    
    private func configureProgramMedicationStackView() {
         let constraintConstant: CGFloat = 20
         
         programMedicationStackView.addArrangedSubview(frequencyLabel)
         programMedicationStackView.addArrangedSubview(frequencyTextField)
         programMedicationStackView.addArrangedSubview(howManyTimesLabel)
         programMedicationStackView.addArrangedSubview(howManyTimesTextField)
         programMedicationStackView.addArrangedSubview(whatTimeLabel)
         programMedicationStackView.addArrangedSubview(whatTimeOnceADayTextField)
         programMedicationStackView.addArrangedSubview(whatTimeTwiceADayTextField)
         programMedicationStackView.addArrangedSubview(whatTimeThreeTimesADayTextField)
         programMedicationStackView.addArrangedSubview(dosageLabel)
         programMedicationStackView.addArrangedSubview(dosageTextField)
         
         frequencyTextField.delegate = self
         howManyTimesTextField.delegate = self
         whatTimeOnceADayTextField.delegate = self
         whatTimeTwiceADayTextField.delegate = self
         whatTimeThreeTimesADayTextField.delegate = self
         dosageTextField.delegate = self
         
         programMedicationStackView.axis = .vertical
         programMedicationStackView.distribution = .fillEqually
         
         scrollView.addSubview(programMedicationStackView)
         programMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             programMedicationStackView.topAnchor.constraint(equalTo: currentMedicationStackView.bottomAnchor, constant: constraintConstant),
             programMedicationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             programMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             programMedicationStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
         ])
     }
    
    private func createPickerView(textField: UITextField) {
        let pickerView = UIPickerView()
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let row = UserDefaults.standard.integer(forKey: "pickerViewRow")
        
        pickerView.delegate = self
        //        pickerView.selectRow(row, inComponent: 0, animated: false)
        textField.inputView = pickerView
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc private func pickerDoneButtonTapped() {
        self.endEditing(true)
    }
}

extension CurrentMedicationSettingsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            return pillModel.frequency[row]
        } else if activeTextField == howManyTimesTextField {
            return pillModel.howManyTimesPerDay[row]
        } else {
            return pillModel.dosage[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let activeTextField = activeTextField else { return }
        //        UserDefaults.standard.set(row, forKey: "pickerViewRow")
        
        if activeTextField == frequencyTextField {
            activeTextField.text = pillModel.frequency[row]
        } else if activeTextField == howManyTimesTextField {
            activeTextField.text = pillModel.howManyTimesPerDay[row]
        } else {
            activeTextField.text = pillModel.dosage[row]
        }
    }
}

extension CurrentMedicationSettingsView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        activeTextField = textField
        
        if textField == frequencyTextField {
            createPickerView(textField: textField)
        } else if textField == howManyTimesTextField {
            createPickerView(textField: textField)
        } else {
            createPickerView(textField: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
