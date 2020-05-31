//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationVC: UIViewController {
    
    private let newMedicationView = UIView()
    private let titleLabel = CustomLabel(text: "Add Medication", alignment: .left, size: 24, weight: .bold, color: .label)
    private let nameTextField = CustomMedicationTextField(placeholderText: "Name e.g. Metocard", isPassword: false)
    private let capacityTextField = CustomMedicationTextField(placeholderText: "Package capacity", isPassword: false)
    private let doseTextField = CustomMedicationTextField(placeholderText: "Dose e.g. 50 (mg)", isPassword: false)
    
    let dose = ["1", "1/2", "1/4"]
    let pickerDoseTextfield = CustomInputField(placeholderText: "click here", isPassword: false)
    var selectedDose: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureMedicationView()
        configureNameTextField()
        configureCapacityTextField()
        configureDoseTextField()
        configureDosePicker()
        
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Constants.mainColor
    }
    
    @objc private func saveSettings() {
        print("saved")
    }
    
    private func configureMedicationView() {
        view.addSubview(newMedicationView)
        newMedicationView.addSubview(titleLabel)
        newMedicationView.translatesAutoresizingMaskIntoConstraints = false
        
//        newMedicationView.layer.borderColor = UIColor.label.cgColor
//        newMedicationView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            newMedicationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            titleLabel.topAnchor.constraint(equalTo: newMedicationView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureNameTextField() {
        newMedicationView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureCapacityTextField() {
        newMedicationView.addSubview(capacityTextField)
        
        NSLayoutConstraint.activate([
            capacityTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            capacityTextField.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            capacityTextField.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            capacityTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDoseTextField() {
        newMedicationView.addSubview(doseTextField)
        
        NSLayoutConstraint.activate([
            doseTextField.topAnchor.constraint(equalTo: capacityTextField.bottomAnchor, constant: 40),
            doseTextField.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            doseTextField.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            doseTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDosePicker() {
        let dosePicker = UIPickerView()
        dosePicker.delegate = self

        pickerDoseTextfield.inputView = dosePicker
        
        newMedicationView.addSubview(pickerDoseTextfield)
        
        NSLayoutConstraint.activate([
            pickerDoseTextfield.topAnchor.constraint(equalTo: doseTextField.bottomAnchor, constant: 60),
            pickerDoseTextfield.leadingAnchor.constraint(equalTo: newMedicationView.leadingAnchor),
            pickerDoseTextfield.trailingAnchor.constraint(equalTo: newMedicationView.trailingAnchor),
            pickerDoseTextfield.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension NewMedicationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dose.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dose[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDose = dose[row]
        pickerDoseTextfield.text = selectedDose
    }
}

