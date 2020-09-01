//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    var pillImage = UIImageView()
    private let medicationStackView = UIStackView()
    
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
        return [.font: UIFont.systemFont(ofSize: 10, weight: .bold), .foregroundColor: UIColor.systemGray2]
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
        
        pillImage.backgroundColor = .systemGray5
        pillImage.contentMode = .scaleAspectFill
        pillImage.layer.masksToBounds = true
        pillImage.layer.cornerRadius = pillImageCornerRadius
        pillImage.image = Images.placeholderImage
        
        addSubview(pillImage)
        pillImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pillImage.topAnchor.constraint(equalTo: self.topAnchor),
            pillImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthAnchorMultiplier),
            pillImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
            medicationStackView.leadingAnchor.constraint(equalTo: pillImage.trailingAnchor, constant: leadingAnchorConstant),
            medicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            medicationStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
