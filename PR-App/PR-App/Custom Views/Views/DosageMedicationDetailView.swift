//
//  DosageMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class DosageMedicationDetailView: UIView {
    
    private let dosageView = CustomInformationView(title: "Dose", input: "2 times a days | Morning, Evening")
    private let doseProgramView = CustomInformationView(title: "Program", input: "Everyday")
    private let capacityPillsLeft = CustomInformationView(title: "Capacity", input: "50 pills left")
    
    private let dosageMedicationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDosageMedicationView()
        configureDosageMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDosageMedicationView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDosageMedicationStackView() {
        dosageMedicationStackView.axis = .vertical
        dosageMedicationStackView.distribution = .equalSpacing
    
        addSubview(dosageMedicationStackView)
        dosageMedicationStackView.addArrangedSubview(dosageView)
        dosageMedicationStackView.addArrangedSubview(doseProgramView)
        dosageMedicationStackView.addArrangedSubview(capacityPillsLeft)
        dosageMedicationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dosageMedicationStackView.topAnchor.constraint(equalTo: self.topAnchor),
            dosageMedicationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dosageMedicationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dosageMedicationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
