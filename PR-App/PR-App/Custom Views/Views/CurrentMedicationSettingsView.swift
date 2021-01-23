//
//  CurrentMedicationSettingsView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

final class CurrentMedicationSettingsView: UIView {
    
    private let pillModel = PillModel()
    private let tapToChangeButton = UIButton()
    private let currentMedicationStackView = UIStackView()
    private let currentProgramMedicationStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let pickerView = UIPickerView()
    private let onceADayDatePickerView = UIDatePicker()
    private let twiceADayDatePickerView = UIDatePicker()
    private let threeTimesADayDatePickerView = UIDatePicker()
    private let userDefaults = UserDefaults.standard
    private let frequencyLabel = PillReminderProgramCustomLabel(text: Constants.frequencyTitle)
    private let howManyTimesLabel = PillReminderProgramCustomLabel(text: Constants.howManyTimesPerDayTitle)
    private let whatTimeLabel = PillReminderProgramCustomLabel(text: Constants.whatTimeTitle)
    private let dosageLabel = PillReminderProgramCustomLabel(text: Constants.dosage)
    private let capacityLabel = PillReminderMainCustomLabel(text: Constants.pills, alignment: .left, size: 16, weight: .light, color: .tertiaryLabel)
    private let doseLabel = PillReminderMainCustomLabel(text: Constants.mgPills, alignment: .left, size: 16, weight: .light, color: .tertiaryLabel)
    
    private(set) var changeMedicationLbl = PillReminderMainCustomLabel(text: Constants.changeMedications, alignment: .left, size: 24, weight: .bold, color: .label)
    private(set) var nameTextField = PillReminderMainCustomTextField(placeholderText: Constants.nameMedication, isPassword: false)
    private(set) var capacityTextField = PillReminderMainCustomTextField(placeholderText: Constants.capacityMedication, isPassword: false)
    private(set) var doseTextField = PillReminderMainCustomTextField(placeholderText: Constants.doseMedication, isPassword: false)
    private(set) var frequencyTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.selectFrequencyInput)
    private(set) var howManyTimesTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.howManyTimesPerDayInput)
    private(set) var whatTimeOnceADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var whatTimeTwiceADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var whatTimeThreeTimesADayTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.whatTimeInput)
    private(set) var dosageTextField = PillReminderProgramCustomTextFields(placeholderText: Constants.chooseDosage)
    private(set) var currentMedicationImage = PillReminderImageView(frame: .zero)
    private(set) var activeTextField: UITextField?
    private(set) var capacityLeadingConstraint: Constraint?
    private(set) var doseLeadingConstraint: Constraint?
    
    var viewModel: CurrentMedicationSettingsViewModel
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    init(viewModel: CurrentMedicationSettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        updateUI()
        configureScrollView()
        configureChangeMedicationLbl()
        configureMedicationImageView()
        configureTapToChangeButton()
        configureCurrentMedicationStackview()
        configureProgramMedicationStackView()
        configureCapacityLabel()
        configureDoseLabel()
        viewModel.suffixTextFieldsDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        guard let medication = viewModel.medications else { return }
        updateTextFields(withModel: medication)
        downloadImage(medication: medication)
        updateCapcityConstraint(with: capacityTextField)
        updateDoseConstraint(with: doseTextField)
        configureHowManyTimesPerDayTextFields(with: howManyTimesTextField)
    }
    
    private func downloadImage(medication: UserMedicationDetailModel) {
        guard let cellImage = medication.cellImage else { return }
        currentMedicationImage.downloadImage(with: cellImage)
    }
    
    private func updateTextFields(withModel medication: UserMedicationDetailModel) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        nameTextField.text = medication.pillName
        capacityTextField.text = medication.capacity
        doseTextField.text = medication.dose
        frequencyTextField.text = medication.frequency
        howManyTimesTextField.text = medication.howManyTimesPerDay
        dosageTextField.text = medication.dosage
        
        //        let onceDate = userDefaults.object(forKey: Constants.defaultsWhatTimeOnceRow) as? Date
        whatTimeOnceADayTextField.text = medication.whatTimeOnceRow
        //        let twiceDate = userDefaults.object(forKey: Constants.defaultsWhatTimeTwiceRow) as? Date
        whatTimeTwiceADayTextField.text = medication.whatTimeTwiceRow
        //        let threeTimesDate = userDefaults.object(forKey: Constants.defaultsWhatTimeThreeRow) as? Date
        whatTimeThreeTimesADayTextField.text = medication.whatTimeThreeRow
    }
    
    private func configureScrollView() {
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureChangeMedicationLbl() {
        let topAnchorConstant: CGFloat = 20
        let heightAnchorConstant: CGFloat = 30
        
        scrollView.addSubview(changeMedicationLbl)
        
        changeMedicationLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(self)
            make.height.equalTo(heightAnchorConstant)
            make.top.equalTo(scrollView).offset(topAnchorConstant)
        }
    }
    
    private func configureMedicationImageView() {
        let medicationImageButtonCornerRadius: CGFloat = 16
        let constraintConstant: CGFloat = 20
        let widthAnchorMultiplier: CGFloat = 0.42
        let heightAnchorMultiplier: CGFloat = 0.24
        
        currentMedicationImage.backgroundColor = .tertiarySystemFill
        currentMedicationImage.layer.cornerRadius = medicationImageButtonCornerRadius
        currentMedicationImage.tintColor = .systemGray
        currentMedicationImage.layer.masksToBounds = true
        currentMedicationImage.isUserInteractionEnabled = true
        
        scrollView.addSubview(currentMedicationImage)
        
        currentMedicationImage.snp.makeConstraints { (make) in
            make.top.equalTo(changeMedicationLbl.snp.bottom).offset(constraintConstant)
            make.leading.equalTo(changeMedicationLbl.snp.leading)
            make.trailing.equalTo(-constraintConstant)
            make.width.equalTo(self).multipliedBy(widthAnchorMultiplier)
            make.height.equalTo(self).multipliedBy(heightAnchorMultiplier)
        }
    }
    
    private func configureTapToChangeButton() {
        let heightAnchorConstant: CGFloat = 25
        
        tapToChangeButton.addTarget(self, action: #selector(tapToChangeButtonTapped), for: .touchUpInside)
        tapToChangeButton.setTitle(Constants.tapToChange, for: .normal)
        tapToChangeButton.backgroundColor = UIColor.backgroundColorTapToChangeLabel
        tapToChangeButton.setTitleColor(.systemBackground, for: .normal)
        tapToChangeButton.layer.masksToBounds = true
        
        currentMedicationImage.addSubview(tapToChangeButton)
        
        tapToChangeButton.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(currentMedicationImage)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc private func tapToChangeButtonTapped() {
        viewModel.currentMedicationDelegate?.imagePickerEvent()
    }
    
    private func configureCurrentMedicationStackview() {
        let constraintConstant = viewModel.setConstraintConstant()
        
        currentMedicationStackView.addArrangedSubview(nameTextField)
        currentMedicationStackView.addArrangedSubview(capacityTextField)
        currentMedicationStackView.addArrangedSubview(doseTextField)
        currentMedicationStackView.axis = .vertical
        currentMedicationStackView.distribution = .equalSpacing
        
        capacityTextField.keyboardType = .numberPad
        doseTextField.keyboardType = .numberPad
        capacityTextField.delegate = self
        doseTextField.delegate = self
        capacityTextField.addTarget(self, action: #selector(textFieldFilter), for: .editingChanged)
        doseTextField.addTarget(self, action: #selector(textFieldFilter), for: .editingChanged)
        
        scrollView.addSubview(currentMedicationStackView)
        
        currentMedicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(currentMedicationImage).offset(constraintConstant)
            make.leading.equalTo(currentMedicationImage.snp.trailing).offset(constraintConstant)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(currentMedicationImage).offset(-constraintConstant)
        }
    }
    
    @objc private func textFieldFilter(_ textField: UITextField) {
        viewModel.setFilterForTextField(text: &textField.text)
    }
    
    private func configureCapacityLabel() {
        capacityTextField.addSubview(capacityLabel)
        capacityLabel.font = UIFont.italicSystemFont(ofSize: 16)
        
        capacityLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(capacityTextField)
            self.capacityLeadingConstraint = make.leading.equalTo(capacityTextField).constraint
        }
    }
    
    private func configureDoseLabel() {
        doseTextField.addSubview(doseLabel)
        doseLabel.font = UIFont.italicSystemFont(ofSize: 16)
        
        doseLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(doseTextField)
            self.doseLeadingConstraint = make.leading.equalTo(doseTextField).constraint
        }
    }
    
    private func updateCapcityConstraint(with textField: UITextField) {
        capacityLabel.text = capacityText(forContent: textField.text)
        let capacityWidth = getWidth(text: textField.text)
        capacityLeadingConstraint?.update(offset: capacityWidth + 2)
        capacityLabel.layoutIfNeeded()
    }
    
    private func updateDoseConstraint(with textField: UITextField) {
        let doseWidth = getWidth(text: textField.text)
        doseLeadingConstraint?.update(offset: doseWidth + 2)
        doseLabel.layoutIfNeeded()
    }
    
    private func configureHowManyTimesPerDayTextFields(with textField: UITextField) {
        if textField.text == pillModel.howManyTimesPerDay[2] {
            whatTimeTwiceADayTextField.isHidden = false
            whatTimeThreeTimesADayTextField.isHidden = false
        } else if textField.text == pillModel.howManyTimesPerDay[1] {
            whatTimeTwiceADayTextField.isHidden = false
            whatTimeThreeTimesADayTextField.isHidden = true
        } else if textField.text == pillModel.howManyTimesPerDay[0] {
            whatTimeTwiceADayTextField.isHidden = true
            whatTimeThreeTimesADayTextField.isHidden = true
        }
    }
    
    private func configureProgramMedicationStackView() {
        let constraintConstant: CGFloat = 30
        
        currentProgramMedicationStackView.addArrangedSubview(frequencyLabel)
        currentProgramMedicationStackView.addArrangedSubview(frequencyTextField)
        currentProgramMedicationStackView.addArrangedSubview(howManyTimesLabel)
        currentProgramMedicationStackView.addArrangedSubview(howManyTimesTextField)
        currentProgramMedicationStackView.addArrangedSubview(whatTimeLabel)
        currentProgramMedicationStackView.addArrangedSubview(whatTimeOnceADayTextField)
        currentProgramMedicationStackView.addArrangedSubview(whatTimeTwiceADayTextField)
        currentProgramMedicationStackView.addArrangedSubview(whatTimeThreeTimesADayTextField)
        currentProgramMedicationStackView.addArrangedSubview(dosageLabel)
        currentProgramMedicationStackView.addArrangedSubview(dosageTextField)
        
        frequencyTextField.delegate = self
        howManyTimesTextField.delegate = self
        whatTimeOnceADayTextField.delegate = self
        whatTimeTwiceADayTextField.delegate = self
        whatTimeThreeTimesADayTextField.delegate = self
        dosageTextField.delegate = self
        
        whatTimeTwiceADayTextField.isHidden = true
        whatTimeThreeTimesADayTextField.isHidden = true
        
        currentProgramMedicationStackView.axis = .vertical
        currentProgramMedicationStackView.distribution = .fillEqually
        currentProgramMedicationStackView.spacing = 10
        
        scrollView.addSubview(currentProgramMedicationStackView)
        
        currentProgramMedicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(currentMedicationStackView.snp.bottom).offset(constraintConstant)
            make.leading.equalTo(changeMedicationLbl.snp.leading)
            make.trailing.equalTo(self).offset(-20)
        }
    }
    
    private func createPickerView(withTextField: UITextField, readUserDefaults: String) {
        //        guard let valueFromUserDefaults = userDefaults.object(forKey: readUserDefaults) as? Int else { return }
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onPickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        pickerView.delegate = self
        //        pickerView.selectRow(valueFromUserDefaults, inComponent: 0, animated: true)
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
    
    private func createDatePickerView(datePickerView: UIDatePicker, withTextField: UITextField, readUserDefaults: String) {
        //        guard let valueFromUserDefaults = userDefaults.object(forKey: readUserDefaults) as? Date else { return }
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        datePickerView.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        //        datePickerView.date = valueFromUserDefaults
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
            //            userDefaults.set(selectedOnce, forKey: Constants.defaultsWhatTimeOnceRow)
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
    
    private func configureFirstDaySchedule() {
        appDelegate?.deletePendingNotification()
        let scheduleFirstPill = ScheduleNotoficationData(textField: whatTimeOnceADayTextField, pillName: nameTextField.text ?? "", time: onceADayDatePickerView.date)
        appDelegate?.scheduleNotification(pillOfTheDay: .first, scheduleNotoficationData: scheduleFirstPill, medicationId: viewModel.medications?.userIdentifier ?? "")
    }
    
    private func configureSecondDaySchedule() {
        appDelegate?.deletePendingNotification()
        let scheduleSecondPill = ScheduleNotoficationData(textField: whatTimeTwiceADayTextField, pillName: nameTextField.text ?? "", time: twiceADayDatePickerView.date)
        appDelegate?.scheduleNotification(pillOfTheDay: .second, scheduleNotoficationData: scheduleSecondPill, medicationId: viewModel.medications?.userIdentifier ?? "")
    }
    
    private func configureThirdDaySchedule() {
        appDelegate?.deletePendingNotification()
        let scheduleThirdPill = ScheduleNotoficationData(textField: whatTimeThreeTimesADayTextField, pillName: nameTextField.text ?? "", time: threeTimesADayDatePickerView.date)
        appDelegate?.scheduleNotification(pillOfTheDay: .last, scheduleNotoficationData: scheduleThirdPill, medicationId: viewModel.medications?.userIdentifier ?? "")
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
}

extension CurrentMedicationSettingsView: UITextFieldDelegate {
    
    func getWidth(text: String?) -> CGFloat {
        let textField = UITextField(frame: .zero)
        textField.text = text
        textField.sizeToFit()
        return textField.frame.size.width
    }
    
    func capacityText(forContent text: String?) -> String {
        viewModel.setCapacityText(text)
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
            createPickerView(withTextField: textField, readUserDefaults: Constants.defaultsFrequencyRow)
        } else if textField == howManyTimesTextField {
            createPickerView(withTextField: textField, readUserDefaults: Constants.defaultsHowManyTimesRow)
        } else if textField == whatTimeOnceADayTextField {
            createDatePickerView(datePickerView: onceADayDatePickerView, withTextField: textField, readUserDefaults: Constants.defaultsWhatTimeOnceRow)
        } else if textField == whatTimeTwiceADayTextField {
            createDatePickerView(datePickerView: twiceADayDatePickerView, withTextField: textField, readUserDefaults: Constants.defaultsWhatTimeTwiceRow)
        } else if textField == whatTimeThreeTimesADayTextField {
            createDatePickerView(datePickerView: threeTimesADayDatePickerView, withTextField: textField, readUserDefaults: Constants.defaultsWhatTimeThreeRow)
        } else if textField == dosageTextField {
            createPickerView(withTextField: textField, readUserDefaults: Constants.defaultsDosageRow)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension CurrentMedicationSettingsView {
    func setSchedule() {
        if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden && !whatTimeThreeTimesADayTextField.isHidden {
            configureFirstDaySchedule()
            configureSecondDaySchedule()
            configureThirdDaySchedule()
        } else if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden {
            configureFirstDaySchedule()
            configureSecondDaySchedule()
        } else {
            configureFirstDaySchedule()
        }
    }
}

extension CurrentMedicationSettingsView: UpdateTextFieldsSuffix {
    func updateSuffix() {
        updateUI()
    }
}
