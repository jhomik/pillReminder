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
    private(set) var whatTimeOnceADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var whatTimeTwiceADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var whatTimeThreeTimesADayTextField = PillReminderProgramCustomTextFields(placeholderText: "What time?")
    private(set) var dosageTextField = PillReminderProgramCustomTextFields(placeholderText: "Choose dosage")
    
    private(set) var frequencyLabel = PillReminderProgramCustomLabel(text: "Frequency")
    private(set) var howManyTimesLabel = PillReminderProgramCustomLabel(text: "How many times per day?")
    private(set) var whatTimeLabel = PillReminderProgramCustomLabel(text: "What time?")
    private(set) var dosageLabel = PillReminderProgramCustomLabel(text: "Dosage")
    
    private let capacityLabel = PillReminderMainCustomLabel(text: "pills", alignment: .left, size: 12, weight: .light, color: .secondarySystemFill)
    
    private let pillModel = PillModel()
    private let newMedicationStackView = UIStackView()
    private let programMedicationStackView = UIStackView()
    private let scrollView = UIScrollView()
    var medicationImageButton = UIButton()
    var medicationImage = UIImageView()
    weak var delegate: UserMedicationDetailDelegate?
    
    var medicationsToChange: UserMedicationDetailModel?
    
    var activeTextField: UITextField?
    private let pickerView = UIPickerView()
    let onceADayDatePickerView = UIDatePicker()
    let twiceADayDatePickerView = UIDatePicker()
    let threeTimesADayDatePickerView = UIDatePicker()
    private let userDefaults = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUserMedicationSettingsView()
        configureScrollView()
        configureAddMedicationLbl()
        configureMedicationImageButton()
        configureMedicationImage()
        configureNewMedicationStackView()
        configureCapacityLabel()
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
        
        capacityTextField.keyboardType = .numberPad
        doseTextField.keyboardType = .numberPad
        capacityTextField.delegate = self
        doseTextField.delegate = self
        capacityTextField.addTarget(self, action: #selector(textFieldFilter), for: .editingChanged)
        doseTextField.addTarget(self, action: #selector(textFieldFilter), for: .editingChanged)

        scrollView.addSubview(newMedicationStackView)
        newMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newMedicationStackView.topAnchor.constraint(equalTo: medicationImageButton.topAnchor, constant: constraintConstant),
            newMedicationStackView.leadingAnchor.constraint(equalTo: medicationImageButton.trailingAnchor, constant: constraintConstant),
            newMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newMedicationStackView.bottomAnchor.constraint(equalTo: medicationImageButton.bottomAnchor, constant: -constraintConstant)
        ])
    }
    
    @objc private func textFieldFilter(_ textField: UITextField) {
        if let text = textField.text, let intText = Int(text) {
            textField.text = "\(intText)"
        } else {
            textField.text = ""
        }
    }
    
    private func configureCapacityLabel() {
        capacityTextField.addSubview(capacityLabel)
        
        NSLayoutConstraint.activate([
            capacityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            capacityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            capacityLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            capacityLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func configureProgramMedicationStackView() {
        let constraintConstant: CGFloat = 30
        
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
   
        whatTimeTwiceADayTextField.isHidden = true
        whatTimeThreeTimesADayTextField.isHidden = true
        
        programMedicationStackView.axis = .vertical
        programMedicationStackView.distribution = .fillEqually
        programMedicationStackView.spacing = 10
        
        scrollView.addSubview(programMedicationStackView)
        programMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            programMedicationStackView.topAnchor.constraint(equalTo: newMedicationStackView.bottomAnchor, constant: constraintConstant),
            programMedicationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            programMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func createPickerView(withTextField: UITextField, readUserDefault: String) {
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onPickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        pickerView.delegate = self
        withTextField.inputView = pickerView
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, doneButton], animated: false)
        withTextField.inputAccessoryView = toolBar
    }
    
    @objc private func onPickerDoneButtonTapped() {
        guard let textField = activeTextField else { return }
        if textField == frequencyTextField {
            let row = pillModel.frequency[pickerView.selectedRow(inComponent: 0)]
            textField.text = row
            userDefaults.set(row, forKey: "frequencyRow")
        } else if textField == howManyTimesTextField {
            let row = pillModel.howManyTimesPerDay[pickerView.selectedRow(inComponent: 0)]
            textField.text = row
            userDefaults.set(row, forKey: "howManyTimesPerdDayRow")
            switch pickerView.selectedRow(inComponent: 0) {
            case 0:
                whatTimeTwiceADayTextField.isHidden = true
                whatTimeThreeTimesADayTextField.isHidden = true
            case 1:
                whatTimeTwiceADayTextField.isHidden = false
                whatTimeThreeTimesADayTextField.isHidden = true
            case 2:
                whatTimeTwiceADayTextField.isHidden = false
                whatTimeThreeTimesADayTextField.isHidden = false
            default:
                break
            }
        } else {
            let row = pillModel.dosage[pickerView.selectedRow(inComponent: 0)]
            textField.text = row
            userDefaults.set(row, forKey: "dosageRow")
        }
        self.endEditing(true)
    }
    
    private func createDatePickerView(datePickerView: UIDatePicker, withTextField: UITextField, readUserDefault: String) {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        datePickerView.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
    
        withTextField.inputView = datePickerView
        withTextField.inputAccessoryView = toolBar
        toolBar.sizeToFit()
        toolBar.setItems([spaceButton, doneButton], animated: false)
    }
    
    @objc private func dateDoneButtonTapped() {
        let formatter = DateFormatter()
        let selectedOnce = onceADayDatePickerView.date
        let selectedTwice = twiceADayDatePickerView.date
        let selectedThree = threeTimesADayDatePickerView.date
        formatter.timeStyle = .short
        
        if activeTextField == whatTimeOnceADayTextField {
            whatTimeOnceADayTextField.text = formatter.string(from: selectedOnce)
            userDefaults.set(selectedOnce, forKey: "whatTimeOnceADayRow")
        } else if activeTextField == whatTimeTwiceADayTextField {
            whatTimeTwiceADayTextField.text = formatter.string(from: selectedTwice)
            userDefaults.set(selectedTwice, forKey: "whatTimeTwiceADayRow")
        } else {
            whatTimeThreeTimesADayTextField.text = formatter.string(from: selectedThree)
            userDefaults.set(selectedThree, forKey: "whatTimeThreeTimesADayRow")
        }
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
            return pillModel.frequency[row]
        } else if activeTextField == howManyTimesTextField {
            return pillModel.howManyTimesPerDay[row]
        } else {
            return pillModel.dosage[row]
        }
    }
}

extension NewMedicationSettingsView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharactersIn = CharacterSet(charactersIn: "0123456789").inverted
        
        return (string.rangeOfCharacter(from: invalidCharactersIn) == nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == capacityTextField || textField == doseTextField {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        
        activeTextField = textField
        
        if textField == frequencyTextField {
            createPickerView(withTextField: textField, readUserDefault: "frequencyRow")
        } else if textField == howManyTimesTextField {
            createPickerView(withTextField: textField, readUserDefault: "howManyTimesPerdDayRow")
        } else if textField == whatTimeOnceADayTextField {
            createDatePickerView(datePickerView: onceADayDatePickerView, withTextField: textField, readUserDefault: "whatTimeOnceADayRow")
        } else if textField == whatTimeTwiceADayTextField {
            createDatePickerView(datePickerView: twiceADayDatePickerView, withTextField: textField, readUserDefault: "whatTimeTwiceADayRow")
        } else if textField == whatTimeThreeTimesADayTextField {
            createDatePickerView(datePickerView: threeTimesADayDatePickerView, withTextField: textField, readUserDefault: "whatTimeThreeTimesADayRow")
        } else if textField == dosageTextField {
            createPickerView(withTextField: textField, readUserDefault: "dosageRow")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
