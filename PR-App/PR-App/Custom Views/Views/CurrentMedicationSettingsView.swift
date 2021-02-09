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
    private let frequencyPickerView = UIPickerView()
    private let howManyTimesPickerView = UIPickerView()
    private let dosagePickerView = UIPickerView()
    private let onceADayDatePickerView = UIDatePicker()
    private let twiceADayDatePickerView = UIDatePicker()
    private let threeTimesADayDatePickerView = UIDatePicker()
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCapcityConstraint(with: capacityTextField)
        updateDoseConstraint(with: doseTextField)
        configureHowManyTimesPerDayTextFields(with: howManyTimesTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        guard let medication = viewModel.medications else { return }
        updateTextFields(withModel: medication)
        downloadImage(medication: medication)
        loadDefaultDatePicker(datePickerView: onceADayDatePickerView)
        loadDefaultDatePicker(datePickerView: twiceADayDatePickerView)
        loadDefaultDatePicker(datePickerView: threeTimesADayDatePickerView)
    }
    
    private func downloadImage(medication: UserMedicationDetailModel) {
        guard let cellImage = medication.cellImage else { return }
        currentMedicationImage.downloadImage(with: cellImage)
    }
    
    private func updateTextFields(withModel medication: UserMedicationDetailModel) {
        nameTextField.text = medication.pillName
        capacityTextField.text = medication.capacity
        doseTextField.text = medication.dose
        frequencyTextField.text = medication.frequency
        howManyTimesTextField.text = medication.howManyTimesPerDay
        dosageTextField.text = medication.dosage
        whatTimeOnceADayTextField.text = medication.whatTimeOnceRow
        whatTimeTwiceADayTextField.text = medication.whatTimeTwiceRow
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
        let topAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard ? 0 : 20
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
        let widthAnchorMultiplier: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard  ? 0.38 : 0.42
        let heightAnchorMultiplier: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard ? 0.22 : 0.24
        
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
        let constraintConstant: CGFloat = DeviceTypes.isiPhoneSE ? 8 : 14
        let topAndBottomConstraint: CGFloat = DeviceTypes.isiPhoneSE ? 0 : 8
        
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
            make.top.equalTo(currentMedicationImage.snp.top).offset(topAndBottomConstraint)
            make.leading.equalTo(currentMedicationImage.snp.trailing).offset(constraintConstant)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(currentMedicationImage.snp.bottom).offset(-topAndBottomConstraint)
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
        let constraintConstant: CGFloat = DeviceTypes.isiPhoneSE ? 10 : 16
        let stackViewSpacing: CGFloat = DeviceTypes.isiPhoneSE ? 6 : 12
        
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
        currentProgramMedicationStackView.spacing = stackViewSpacing
        
        scrollView.addSubview(currentProgramMedicationStackView)
        
        currentProgramMedicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(currentMedicationStackView.snp.bottom).offset(constraintConstant)
            make.leading.equalTo(changeMedicationLbl.snp.leading)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    private func createPickerView(withTextField: UITextField, pickerView: UIPickerView) {
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
            howManyTimesTextField.becomeFirstResponder()
            let row = frequencyPickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.frequency[row]
            textField.text = rowSelected
        } else if textField == howManyTimesTextField {
            whatTimeOnceADayTextField.becomeFirstResponder()
            let row = howManyTimesPickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.howManyTimesPerDay[row]
            textField.text = rowSelected
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
            let row = dosagePickerView.selectedRow(inComponent: 0)
            let rowSelected = pillModel.dosage[row]
            textField.text = rowSelected
            dosageTextField.resignFirstResponder()
            self.endEditing(true)
        }
    }
    
    private func loadDefaultDatePicker(datePickerView: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        if datePickerView == onceADayDatePickerView {
            let selectedRow = formatter.date(from: viewModel.medications?.whatTimeOnceRow ?? "")
            datePickerView.date = selectedRow ?? Date()
        } else if datePickerView == twiceADayDatePickerView {
            let selectedRow = formatter.date(from: viewModel.medications?.whatTimeTwiceRow ?? "")
            datePickerView.date = selectedRow ?? Date()
        } else if datePickerView == threeTimesADayDatePickerView {
            let selectedRow = formatter.date(from: viewModel.medications?.whatTimeThreeRow ?? "")
            datePickerView.date = selectedRow ?? Date()
        }
    }
    
    private func createDatePickerView(datePickerView: UIDatePicker, withTextField: UITextField) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        datePickerView.datePickerMode = .time
        datePickerView.locale = .current
        
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
            if !whatTimeTwiceADayTextField.isHidden {
                whatTimeTwiceADayTextField.becomeFirstResponder()
            } else {
                dosageTextField.becomeFirstResponder()
            }
            let selectedOnce = onceADayDatePickerView.date
            let time = formatter.string(from: selectedOnce)
            whatTimeOnceADayTextField.text = time
        } else if activeTextField == whatTimeTwiceADayTextField {
            if !whatTimeThreeTimesADayTextField.isHidden {
                whatTimeThreeTimesADayTextField.becomeFirstResponder()
            } else {
                dosageTextField.becomeFirstResponder()
            }
            let selectedTwice = twiceADayDatePickerView.date
            let time = formatter.string(from: selectedTwice)
            whatTimeTwiceADayTextField.text = time
        } else {
            dosageTextField.becomeFirstResponder()
            let selectedThree = threeTimesADayDatePickerView.date
            let time = formatter.string(from: selectedThree)
            whatTimeThreeTimesADayTextField.text = time
        }
    }
    
    private func configureFirstDaySchedule(medicationModel: UserMedicationDetailModel?) {
        let scheduleFirstPill = ScheduleNotoficationData(textField: whatTimeOnceADayTextField, pillName: nameTextField.text ?? "", time: onceADayDatePickerView.date)
        appDelegate?.updateNotofication(pillOfTheDay: .first, schedule: scheduleFirstPill, medicationModel: medicationModel)
    }
    
    private func configureSecondDaySchedule(medicationModel: UserMedicationDetailModel?) {
        let scheduleSecondPill = ScheduleNotoficationData(textField: whatTimeTwiceADayTextField, pillName: nameTextField.text ?? "", time: twiceADayDatePickerView.date)
        appDelegate?.updateNotofication(pillOfTheDay: .second, schedule: scheduleSecondPill, medicationModel: medicationModel)
    }
    
    private func configureThirdDaySchedule(medicationModel: UserMedicationDetailModel?) {
        let scheduleThirdPill = ScheduleNotoficationData(textField: whatTimeThreeTimesADayTextField, pillName: nameTextField.text ?? "", time: threeTimesADayDatePickerView.date)
        appDelegate?.updateNotofication(pillOfTheDay: .last, schedule: scheduleThirdPill, medicationModel: medicationModel)
    }
}

extension CurrentMedicationSettingsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == frequencyPickerView {
            return pillModel.frequency.count
        } else if pickerView == howManyTimesPickerView {
            return pillModel.howManyTimesPerDay.count
        } else {
            return pillModel.dosage.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == frequencyPickerView {
            if row == pillModel.frequency.firstIndex(where: { $0 == viewModel.medications?.frequency }) {
                pickerView.selectRow(row, inComponent: 0, animated: false)
            }
            return pillModel.frequency[row]
        } else if pickerView == howManyTimesPickerView {
            if row == pillModel.howManyTimesPerDay.firstIndex(where: { $0 == viewModel.medications?.howManyTimesPerDay }) {
                pickerView.selectRow(row, inComponent: 0, animated: false)
            }
            return pillModel.howManyTimesPerDay[row]
        } else {
            if row == pillModel.dosage.firstIndex(where: { $0 == viewModel.medications?.dosage }) {
                pickerView.selectRow(row, inComponent: 0, animated: false)
            }
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
        } else if textField == frequencyTextField || textField == howManyTimesTextField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 280), animated: true)
        }
        
        activeTextField = textField
        
        if textField == frequencyTextField {
            createPickerView(withTextField: textField, pickerView: frequencyPickerView)
        } else if textField == howManyTimesTextField {
            createPickerView(withTextField: textField, pickerView: howManyTimesPickerView)
        } else if textField == whatTimeOnceADayTextField {
            createDatePickerView(datePickerView: onceADayDatePickerView, withTextField: textField)
        } else if textField == whatTimeTwiceADayTextField {
            createDatePickerView(datePickerView: twiceADayDatePickerView, withTextField: textField)
        } else if textField == whatTimeThreeTimesADayTextField {
            createDatePickerView(datePickerView: threeTimesADayDatePickerView, withTextField: textField)
        } else if textField == dosageTextField {
            createPickerView(withTextField: textField, pickerView: dosagePickerView)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension CurrentMedicationSettingsView {
    func setSchedule(medicationModel: UserMedicationDetailModel?) {
        if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden && !whatTimeThreeTimesADayTextField.isHidden {
            configureFirstDaySchedule(medicationModel: medicationModel)
            configureSecondDaySchedule(medicationModel: medicationModel)
            configureThirdDaySchedule(medicationModel: medicationModel)
        } else if !whatTimeOnceADayTextField.isHidden && !whatTimeTwiceADayTextField.isHidden {
            configureFirstDaySchedule(medicationModel: medicationModel)
            configureSecondDaySchedule(medicationModel: medicationModel)
        } else {
            configureFirstDaySchedule(medicationModel: medicationModel)
        }
    }
}
