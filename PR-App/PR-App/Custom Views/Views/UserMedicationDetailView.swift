//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    var pillImageView = UIImageView()
    var firebaseManager = FirebaseManager()
    private let medicationStackView = UIStackView()
    var medicationToChange: UserMedicationDetailModel? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var pillNameView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.pillName,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var packageCapacityView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.capacity,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var pillDoseView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.dose,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.systemGray2]
    }()
    
    private lazy var inputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.mainColor]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMedicationView()
        configurePillImageView()
        configureMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        guard let medication = medicationToChange else { return }
        updatePillNameValue(medication.pillName)
        updatePackageCapacityValue(medication.capacity)
        updatePillDoseValue(medication.dose)
        firebaseManager.downloadImage(with: medication.cellImage ?? "", imageCell: pillImageView)
    }
    
    func updatePillNameValue(_ value: String) {
        self.pillNameView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    func updatePackageCapacityValue(_ value: String) {
        self.packageCapacityView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    func updatePillDoseValue(_ value: String) {
        self.pillDoseView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    private func configureMedicationView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurePillImageView() {
        let pillImageCornerRadius: CGFloat = 16
        let widthAnchorMultiplier: CGFloat = 0.5
        
        pillImageView.backgroundColor = .systemGray5
        pillImageView.contentMode = .scaleAspectFill
        pillImageView.layer.masksToBounds = true
        pillImageView.layer.cornerRadius = pillImageCornerRadius
        
        addSubview(pillImageView)
        pillImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pillImageView.topAnchor.constraint(equalTo: self.topAnchor),
            pillImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            pillImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureMedicationStackView() {
        let leadingAnchorConstant: CGFloat = 30
        
        medicationStackView.axis = .vertical
        medicationStackView.distribution = .equalSpacing
        
        addSubview(medicationStackView)
        medicationStackView.addArrangedSubview(pillNameView)
        medicationStackView.addArrangedSubview(packageCapacityView)
        medicationStackView.addArrangedSubview(pillDoseView)
        medicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationStackView.topAnchor.constraint(equalTo: self.topAnchor),
            medicationStackView.leadingAnchor.constraint(equalTo: pillImageView.trailingAnchor, constant: leadingAnchorConstant),
            medicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            medicationStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
