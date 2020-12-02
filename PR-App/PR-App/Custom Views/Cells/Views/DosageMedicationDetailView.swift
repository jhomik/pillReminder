//
//  DosageMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class DosageMedicationDetailView: UIView {
    
    private let pillModel = PillModel()
    private let dosageMedicationStackView = UIStackView()
    var medicationToChange: UserMedicationDetailModel? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var dosageView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.dosage, attributes: self.titleAttributes),
        input: NSAttributedString(string: "", attributes: self.inputAttributes))
    
    private lazy var doseProgramView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.program, attributes: self.titleAttributes),
        input: NSAttributedString(string: Constants.everyDay, attributes: self.inputAttributes))
    
    private lazy var capacityPillsLeft = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.capacity, attributes: self.titleAttributes),
        input: NSAttributedString(string: "", attributes: self.inputAttributes))
    
    private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor: UIColor.label]
    }()
    
    private lazy var inputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.secondaryLabel]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDosageMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        guard let medication = medicationToChange else { return }
        configureDoseInformations(medication: medication)
        updatePillsLeft(medication.capacity)
    }
    
    func configureDoseInformations(medication: UserMedicationDetailModel) {
        if medication.howManyTimesPerDay == pillModel.howManyTimesPerDay[0] {
            updateDose(Constants.onceADay)
        } else if medication.howManyTimesPerDay == pillModel.howManyTimesPerDay[1] {
            updateDose(Constants.twiceADay)
        } else {
            updateDose(Constants.threeTimesADay)
        }
    }
    
    private func configureDosageMedicationStackView() {
        dosageMedicationStackView.axis = .vertical
        dosageMedicationStackView.distribution = .equalSpacing
        
        self.addSubview(dosageMedicationStackView)
        dosageMedicationStackView.addArrangedSubview(dosageView)
        dosageMedicationStackView.addArrangedSubview(doseProgramView)
        dosageMedicationStackView.addArrangedSubview(capacityPillsLeft)
        
        dosageMedicationStackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    func updateDose(_ value: String) {
        self.dosageView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    func updatePillsLeft(_ value: String) {
        guard let amount = Int(value) else { return }
        if amount <= 1 {
            self.capacityPillsLeft.updateInputValue(NSAttributedString(string: Constants.pillLeft + value + Constants.pill, attributes: self.inputAttributes))
        } else {
            self.capacityPillsLeft.updateInputValue(NSAttributedString(string: Constants.pillsLeft + value + Constants.pills, attributes: self.inputAttributes))
        }
    }
}
