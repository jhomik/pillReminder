//
//  NewMedicationSettingsView.swift
//  PR-App
//
//  Created by Jakub Homik on 04/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

protocol UserMedicationDetailDelegate: AnyObject {
    func imagePickerEvent()
}

struct ScheduleNotoficationData {
    var textField: UITextField
    let pillName: String
    let time: Date
    var identifier: String
}

final class NewMedicationSettingsView: UIView {
    
    private(set) var addMedicationLbl = PillReminderMainCustomLabel(text: Constants.addMedication, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = PillReminderMainCustomTextField(placeholderText: Constants.nameMedication, isPassword: false)
    private(set) var capacityTextField = PillReminderMainCustomTextField(placeholderText: Constants.capacityMedication, isPassword: false)
    private(set) var doseTextField = PillReminderMainCustomTextField(placeholderText: Constants.doseMedication, isPassword: false)
    private(set) var frequencyTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.selectFrequencyInput)
    private(set) var howManyTimesTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.howManyTimesPerDayInput)
    private(set) var whatTimeOnceADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var whatTimeTwiceADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var whatTimeThreeTimesADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var dosageTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.chooseDosage)
    private(set) var frequencyLabel = PillReminderProgramCustomLabel(text: Constants.frequencyTitle)
    private(set) var howManyTimesLabel = PillReminderProgramCustomLabel(text: Constants.howManyTimesPerDayTitle)
    private(set) var whatTimeLabel = PillReminderProgramCustomLabel(text: Constants.whatTimeTitle)
    private(set) var dosageLabel = PillReminderProgramCustomLabel(text: Constants.dosage)
    private let capacityLabel = PillReminderMainCustomLabel(text: Constants.pills, alignment: .left, size: 16, weight: .light, color: .tertiaryLabel)
    private let doseLabel = PillReminderMainCustomLabel(text: Constants.mgPills, alignment: .left, size: 16, weight: .light, color: .tertiaryLabel)
    private let pillModel = PillModel()
    private let newMedicationStackView = UIStackView()
    private let programMedicationStackView = UIStackView()
    private let scrollView = UIScrollView()
    var medicationImageButton = UIButton()
    var medicationImage = UIImageView()
    weak var delegate: UserMedicationDetailDelegate?
    private(set) var activeTextField: UITextField?
    private let pickerView = UIPickerView()
    let onceADayDatePickerView = UIDatePicker()
    let twiceADayDatePickerView = UIDatePicker()
    let threeTimesADayDatePickerView = UIDatePicker()
    private let userDefaults = UserDefaults.standard
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var capacityLeadingConstraint: Constraint?
    private var doseLeadingConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
        configureAddMedicationLbl()
        configureMedicationImageButton()
        configureMedicationImage()
        configureNewMedicationStackView()
        configureCapacityLabel()
        configureDoseLabel()
        configureProgramMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    private func configureAddMedicationLbl() {
        let topAnchorConstant: CGFloat = 12
        let heightAnchorConstant: CGFloat = 30
        
        scrollView.addSubview(addMedicationLbl)
        
        addMedicationLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(heightAnchorConstant)
            make.top.equalTo(scrollView).offset(topAnchorConstant)
        }
    }
    
    private func configureMedicationImageButton() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let medicationImageButtonCornerRadius: CGFloat = 16
        let constraintConstant: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.42
        let heightAnchorMultiplier: CGFloat = 0.24
        
        medicationImageButton.backgroundColor = .systemGray5
        medicationImageButton.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationImageButton.setImage(UIImage(systemName: Images.cameraImage, withConfiguration: settingsCellConfig), for: .normal)
        medicationImageButton.layer.cornerRadius = medicationImageButtonCornerRadius
        medicationImageButton.tintColor = .systemGray
        medicationImageButton.layer.masksToBounds = true
        
        scrollView.addSubview(medicationImageButton)
        
        medicationImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(addMedicationLbl.snp.bottom).offset(constraintConstant)
            make.leading.equalTo(self)
            make.trailing.equalTo(constraintConstant)
            make.width.equalTo(self).multipliedBy(widthAnchorMultiplier)
            make.height.equalTo(self).multipliedBy(heightAnchorMultiplier)
        }
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
        
        medicationImage.snp.makeConstraints { (make) in
            make.top.leading.width.height.equalTo(medicationImageButton)
        }
    }
    
    private func configureNewMedicationStackView() {
        let constraintConstant: CGFloat = DeviceTypes.isiPhoneSE ? 0 : 14
        
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
        
        newMedicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(medicationImageButton).offset(constraintConstant)
            make.leading.equalTo(medicationImageButton.snp.trailing).offset(constraintConstant)
            make.trailing.equalTo(self)
            make.bottom.equalTo(medicationImageButton).offset(-constraintConstant)
        }
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
        capacityLabel.font = UIFont.italicSystemFont(ofSize: 16)
        capacityLabel.isHidden = true
        
        capacityLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(capacityTextField)
            self.capacityLeadingConstraint = make.leading.equalTo(capacityTextField).constraint
        }
    }
    
    private func configureDoseLabel() {
        doseTextField.addSubview(doseLabel)
        doseLabel.font = UIFont.italicSystemFont(ofSize: 16)
        doseLabel.isHidden = true
        
        doseLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(doseTextField)
            self.doseLeadingConstraint = make.leading.equalTo(doseTextField).constraint
        }
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
        
        programMedicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(newMedicationStackView.snp.bottom).offset(constraintConstant)
            make.leading.trailing.equalTo(self)
        }
    }
    
    private func createPickerView(withTextField: UITextField) {
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
            let row = pickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.frequency[row]
            textField.text = rowSelected
//            userDefaults.set(row, forKey: Constants.defaultsFrequencyRow)
        } else if textField == howManyTimesTextField {
            let row = pickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.howManyTimesPerDay[row]
            textField.text = rowSelected
//            userDefaults.set(row, forKey: Constants.defaultsHowManyTimesRow)
            switch row {
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
            let row = pickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.dosage[row]
            textField.text = rowSelected
//            userDefaults.set(row, forKey: Constants.defaultsDosageRow)
        }
        self.endEditing(true)
    }
    
    private func createDatePickerView(datePickerView: UIDatePicker, withTextField: UITextField) {
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
        formatter.timeStyle = .short
        
        if activeTextField == whatTimeOnceADayTextField {
            let selectedOnce = onceADayDatePickerView.date
            let time = formatter.string(from: selectedOnce)
            whatTimeOnceADayTextField.text = time
            userDefaults.set(selectedOnce, forKey: Constants.defaultsWhatTimeOnceRow)
            print(selectedOnce)
        } else if activeTextField == whatTimeTwiceADayTextField {
            let selectedTwice = twiceADayDatePickerView.date
            let time = formatter.string(from: selectedTwice)
            whatTimeTwiceADayTextField.text = time
//            userDefaults.set(selectedTwice, forKey: Constants.defaultsWhatTimeTwiceRow)
        } else {
            let selectedThree = threeTimesADayDatePickerView.date
            let time = formatter.string(from: selectedThree)
            whatTimeThreeTimesADayTextField.text = time
//            userDefaults.set(selectedThree, forKey: Constants.defaultsWhatTimeThreeRow)
        }
        self.endEditing(true)
    }
    
    private func configureFirstDaySchedule(for medicationId: String?) {
        let scheduleFirstPill = ScheduleNotoficationData(textField: whatTimeOnceADayTextField, pillName: nameTextField.text ?? "", time: onceADayDatePickerView.date, identifier: UUID().uuidString)
        appDelegate?.scheduleNotification(pillOfTheDay: .first, scheduleNotoficationData: scheduleFirstPill, medicationId: medicationId)
    }
    
    private func configureSecondDaySchedule(for medicationId: String?) {
        let scheduleSecondPill = ScheduleNotoficationData(textField: whatTimeTwiceADayTextField, pillName: nameTextField.text ?? "", time: twiceADayDatePickerView.date, identifier: UUID().uuidString)
        appDelegate?.scheduleNotification(pillOfTheDay: .second, scheduleNotoficationData: scheduleSecondPill, medicationId: medicationId)
    }
    
    private func configureThirdDaySchedule(for medicationId: String?) {
        let scheduleThirdPill = ScheduleNotoficationData(textField: whatTimeThreeTimesADayTextField, pillName: nameTextField.text ?? "", time: threeTimesADayDatePickerView.date, identifier: UUID().uuidString)
        appDelegate?.scheduleNotification(pillOfTheDay: .last, scheduleNotoficationData: scheduleThirdPill, medicationId: medicationId)
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
    
    func getWidth(text: String?) -> CGFloat {
        let textField = UITextField(frame: .zero)
        textField.text = text
        textField.sizeToFit()
        return textField.frame.size.width
    }
    
    func capacityText(forContent text: String?) -> String {
        guard let text = text, let amount = Int(text) else { return "" }
        if amount <= 1 {
            return Constants.pill
        } else {
            return Constants.pills
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == capacityTextField {
            capacityLabel.text = capacityText(forContent: textField.text)
            let capacityWidth = getWidth(text: textField.text)
            capacityLeadingConstraint?.update(offset: capacityWidth + 2)
            capacityLabel.layoutIfNeeded()
        } else if textField == doseTextField {
            let doseWidth = getWidth(text: textField.text)
            doseLeadingConstraint?.update(offset: doseWidth + 2)
            doseLabel.layoutIfNeeded()
        }
        
        guard let capacity = capacityTextField.text, let dose = doseTextField.text else { return }
        
        if !capacity.isEmpty {
            capacityLabel.isHidden = false
        } else {
            capacityLabel.isHidden = true
        }
        
        if !dose.isEmpty {
            doseLabel.isHidden = false
        } else {
            doseLabel.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        let invalidCharactersIn = CharacterSet(charactersIn: "0123456789").inverted
        
        return (string.rangeOfCharacter(from: invalidCharactersIn) == nil) && newLength <= 3
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == capacityTextField || textField == doseTextField {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        
        activeTextField = textField
        
        if textField == frequencyTextField {
            createPickerView(withTextField: textField)
        } else if textField == howManyTimesTextField {
            createPickerView(withTextField: textField)
        } else if textField == whatTimeOnceADayTextField {
            createDatePickerView(datePickerView: onceADayDatePickerView, withTextField: textField)
        } else if textField == whatTimeTwiceADayTextField {
            createDatePickerView(datePickerView: twiceADayDatePickerView, withTextField: textField)
        } else if textField == whatTimeThreeTimesADayTextField {
            createDatePickerView(datePickerView: threeTimesADayDatePickerView, withTextField: textField)
        } else if textField == dosageTextField {
            createPickerView(withTextField: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension NewMedicationSettingsView {
    func setSchedule(medicationId: String?) {
        if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden && !whatTimeThreeTimesADayTextField.isHidden {
            configureFirstDaySchedule(for: medicationId)
            configureSecondDaySchedule(for: medicationId)
            configureThirdDaySchedule(for: medicationId)
        } else if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden {
            configureFirstDaySchedule(for: medicationId)
            configureSecondDaySchedule(for: medicationId)
        } else {
            configureFirstDaySchedule(for: medicationId)
        }
    }
}
