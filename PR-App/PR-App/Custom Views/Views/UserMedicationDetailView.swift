//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    private let medicationStackView = UIStackView()
    private let dosageMedicationStackView = UIStackView()
    private let editButton = PillReminderMainCustomButton(text: Constants.changeSettings)

    var pillImageView = PillReminderImageView(frame: .zero)
    private(set) var viewModel: UserMedicationDetailViewModel
    
    private lazy var pillNameView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.pillName,
                                  attributes: self.informationTitleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.informationInputAttributes))
    
    private lazy var packageCapacityView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.capacity,
                                  attributes: self.informationTitleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.informationInputAttributes))
    
    private(set) lazy var pillDoseView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.dose,
                                  attributes: self.informationTitleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.informationInputAttributes))
    
    private lazy var dosageView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.dosage, attributes: self.programAndDosageTitleAttributes),
        input: NSAttributedString(string: "", attributes: self.programAndDosageInputAttributes))
    
    private lazy var doseProgramView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.program, attributes: self.programAndDosageTitleAttributes),
        input: NSAttributedString(string: Constants.everyDay, attributes: self.programAndDosageInputAttributes))
    
    private lazy var capacityPillsLeft = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.capacity, attributes: self.programAndDosageTitleAttributes),
        input: NSAttributedString(string: "", attributes: self.programAndDosageInputAttributes))
    
    private(set) lazy var informationTitleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.systemGray2]
    }()
    
    private(set) lazy var informationInputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.mainColor]
    }()
    
    private lazy var programAndDosageTitleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor: UIColor.label]
    }()
    
    private lazy var programAndDosageInputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
    }()
    
    init(viewModel: UserMedicationDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        updateUI()
        configurePillImageView()
        configureMedicationStackView()
        configureDosageMedicationStackView()
        configureEditButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        guard let medications = viewModel.medications else { return }
        updatePillNameValue(medications.pillName)
        updatePackageCapacityValue(medications.capacity)
        updatePillDoseValue(medications.dose ?? "")
        downloadImage(medication: medications)
        updateDoseProgram()
        if let leftPills = viewModel.leftCapacity {
            updatePillsLeft(leftPills)
        }
    }
    
    private func configurePillImageView() {
        let widthAnchorMultiplier: CGFloat = 0.4
        let heightAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE ? 160 : 180
        
        self.addSubview(pillImageView)
        
        pillImageView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(30)
            make.height.equalTo(heightAnchorConstant)
            make.width.equalTo(self).multipliedBy(widthAnchorMultiplier)
        }
    }
    
    private func configureMedicationStackView() {
        let constraintConstant: CGFloat = DeviceTypes.isiPhoneSE ? 16 : 30
    
        medicationStackView.axis = .vertical
        medicationStackView.distribution = .equalSpacing
        self.addSubview(medicationStackView)
        medicationStackView.addArrangedSubview(pillNameView)
        medicationStackView.addArrangedSubview(packageCapacityView)
        medicationStackView.addArrangedSubview(pillDoseView)
        
        medicationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(pillImageView.snp.top)
            make.leading.equalTo(pillImageView.snp.trailing).offset(constraintConstant)
            make.trailing.equalTo(-constraintConstant)
            make.bottom.equalTo(pillImageView.snp.bottom)
        }
    }
    
    private func configureDosageMedicationStackView() {
        let topAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE ? 15 : 30
        let heightAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE ? 160 : 200
        
        dosageMedicationStackView.axis = .vertical
        dosageMedicationStackView.distribution = .equalSpacing
        
        self.addSubview(dosageMedicationStackView)
        dosageMedicationStackView.addArrangedSubview(dosageView)
        dosageMedicationStackView.addArrangedSubview(doseProgramView)
        dosageMedicationStackView.addArrangedSubview(capacityPillsLeft)
        
        dosageMedicationStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(pillImageView.snp.leading)
            make.top.equalTo(pillImageView.snp.bottom).offset(topAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    // TODO: Change location of calling method downloadImage
    private func downloadImage(medication: UserMedicationDetailModel) {
        guard let cellImage = medication.cellImage else { return }
        pillImageView.downloadImage(with: cellImage)
    }
    
    func updatePillNameValue(_ value: String) {
        self.pillNameView.updateInputValue(NSAttributedString(string: value, attributes: self.informationInputAttributes))
    }
    
    func updatePackageCapacityValue(_ value: String) {
        self.packageCapacityView.updateInputValue(NSAttributedString(string: viewModel.setPackageSuffixLabel(value), attributes: self.informationInputAttributes))
    }
    
    func updatePillDoseValue(_ value: String) {
        self.pillDoseView.updateInputValue(NSAttributedString(string: value + Constants.mgPills, attributes: self.informationInputAttributes))
    }
    
    func updateDoseProgram() {
        self.dosageView.updateInputValue(NSAttributedString(string: viewModel.configureDoseInformations(), attributes: self.programAndDosageInputAttributes))
    }
    
    func updatePillsLeft(_ value: String) {
        self.capacityPillsLeft.updateInputValue(NSAttributedString(string: viewModel.setPillsLeftLabel(value), attributes: self.programAndDosageInputAttributes))
    }

    private func configureEditButton() {
        let bottomAnchorConstant: CGFloat = 30
        let heightAnchorConstant: CGFloat = 40
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        self.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.leading.equalTo(pillImageView.snp.leading)
            make.trailing.equalTo(medicationStackView.snp.trailing)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-bottomAnchorConstant)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    @objc private func editButtonTapped() {
        viewModel.buttonTappedDelegate?.editButtonTapped()
    }
}
