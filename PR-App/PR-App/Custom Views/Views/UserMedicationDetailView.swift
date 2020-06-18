//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    private lazy var pillNameView = CustomInformationView(
        title: NSAttributedString(string: "Pill name",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "Metocard",
                                  attributes: self.inputAttributes))
    
    private lazy var packageCapacityView = CustomInformationView(
        title: NSAttributedString(string: "Capacity",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "60 pills",
                                  attributes: self.inputAttributes))
    
    private lazy var pillDoseView = CustomInformationView(
        title: NSAttributedString(string: "Dose",
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "50 mg",
                                  attributes: self.inputAttributes))
    
    private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 10,
                                         weight: .bold),
                .foregroundColor: UIColor.systemGray2]
    }()
    
    private lazy var inputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24,
                                         weight: .medium),
                .foregroundColor: Constants.mainColor]
    }()
    
//    private let pillNameView = CustomInformationView(title: "Pill name", input: "Metocard")
//    private let packageCapacityView = CustomInformationView(title: "Capacity", input: "60 pills")
//    private let pillDoseView = CustomInformationView(title: "Dose", input: "50 mg")
    
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
        
        addSubview(medicationButtonCamera)
        medicationButtonCamera.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            medicationButtonCamera.topAnchor.constraint(equalTo: self.topAnchor),
            medicationButtonCamera.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            medicationButtonCamera.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            medicationButtonCamera.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func imageCameraButtonTapped() {
        print("button tapped")
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
