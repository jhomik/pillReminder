//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    var viewModel = UserMedicationInfoViewModel()
    var pillImage = UIImageView()
    
    private lazy var pillNameView = TitleAndInputMedicationView(
        title: NSAttributedString(string: "Pill name",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var packageCapacityView = TitleAndInputMedicationView(
        title: NSAttributedString(string: "Capacity",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var pillDoseView = TitleAndInputMedicationView(
        title: NSAttributedString(string: "Dose",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 10, weight: .bold), .foregroundColor: UIColor.systemGray2]
    }()
    
    private lazy var inputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: Constants.mainColor]
    }()
    
    private var medicationButtonCamera = UIButton()
    private let medicationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMedicationView()
        configureMedicationButtonCamera()
        configureMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePillNameValue(_ value: String) {
        self.pillNameView.updateInputValue(NSAttributedString(string: value,
                                                              attributes: self.inputAttributes))
    }
    
    func updatePackageCapacityValue(_ value: String) {
        self.packageCapacityView.updateInputValue(NSAttributedString(string: value,
                                                                    attributes: self.inputAttributes))
    }
    
    func updatePillDoseValue(_ value: String) {
        self.pillDoseView.updateInputValue(NSAttributedString(string: value,
                                                              attributes: self.inputAttributes))
    }
    
    private func configureMedicationView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureMedicationButtonCamera() {
        let settingsCellConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        medicationButtonCamera.backgroundColor = .systemGray5
        medicationButtonCamera.addTarget(self, action: #selector(imageCameraButtonTapped), for: .touchUpInside)
        medicationButtonCamera.setImage(UIImage(systemName: "camera", withConfiguration: settingsCellConfig), for: .normal)
        medicationButtonCamera.layer.cornerRadius = 16
        medicationButtonCamera.tintColor = .systemGray
        pillImage.layer.masksToBounds = true
        pillImage.layer.cornerRadius = 16
        
        addSubview(medicationButtonCamera)
        medicationButtonCamera.addSubview(pillImage)
        pillImage.translatesAutoresizingMaskIntoConstraints = false
        medicationButtonCamera.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationButtonCamera.topAnchor.constraint(equalTo: self.topAnchor),
            medicationButtonCamera.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationButtonCamera.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            medicationButtonCamera.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            pillImage.topAnchor.constraint(equalTo: self.topAnchor),
            pillImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pillImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            pillImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
        //
    }
    
    private func configureMedicationStackView() {
        medicationStackView.axis = .vertical
        medicationStackView.distribution = .equalSpacing
        
        addSubview(medicationStackView)
        medicationStackView.addArrangedSubview(pillNameView)
        medicationStackView.addArrangedSubview(packageCapacityView)
        medicationStackView.addArrangedSubview(pillDoseView)
        medicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationStackView.topAnchor.constraint(equalTo: self.topAnchor),
            medicationStackView.leadingAnchor.constraint(equalTo: medicationButtonCamera.trailingAnchor, constant: 30),
            medicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            medicationStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
