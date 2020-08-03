////
////  ProgramMedicationView.swift
////  PR-App
////
////  Created by Jakub Homik on 01/06/2020.
////  Copyright © 2020 Jakub Homik. All rights reserved.
////
//
//import UIKit
//
//final class ProgramMedicationView: UIView {
//
//    private var viewModel = PillModelViewModel()
//
//    private let morningPickerView = UIPickerView()
//    private let noonPickerView = UIPickerView()
//    private let eveningPickerView = UIPickerView()
//    private let programPickerView = UIPickerView()
//
//    private let pickerStackView = UIStackView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureProgramMedicationView()
//        configurePickerStackView()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configureProgramMedicationView() {
//        self.addSubview(setupProgramLbl)
//        self.addSubview(infoProgramLbl)
//        translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            setupProgramLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
//            setupProgramLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            setupProgramLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            setupProgramLbl.heightAnchor.constraint(equalToConstant: 40),
//
//            infoProgramLbl.topAnchor.constraint(equalTo: setupProgramLbl.bottomAnchor, constant: 10),
//            infoProgramLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            infoProgramLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            infoProgramLbl.heightAnchor.constraint(equalToConstant: 16),
//        ])
//    }
//
//    private func configurePickerStackView() {
//        morningPickerView.delegate = self
//        morningPickerView.dataSource = self
//
//        noonPickerView.delegate = self
//        noonPickerView.dataSource = self
//
//        eveningPickerView.delegate = self
//        eveningPickerView.dataSource = self
//
//        pickerStackView.distribution = .equalCentering
//        pickerStackView.axis = .horizontal
//        pickerStackView.addArrangedSubview(morningPickerView)
//        pickerStackView.addArrangedSubview(noonPickerView)
//        pickerStackView.addArrangedSubview(eveningPickerView)
//        self.addSubview(pickerStackView)
//        pickerStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            pickerStackView.topAnchor.constraint(equalTo: infoProgramLbl.bottomAnchor),
//            pickerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            pickerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            pickerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
//
//            morningPickerView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//            morningPickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//
//            noonPickerView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//            noonPickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//
//            eveningPickerView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//            eveningPickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
//        ])
//    }
//}
//
//extension ProgramMedicationView: UIPickerViewDataSource, UIPickerViewDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//        if pickerView == morningPickerView {
//            return dataForPicker.morning.count
//        } else if pickerView == noonPickerView {
//            return dataForPicker.noon.count
//        } else {
//            return dataForPicker.evening.count
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == morningPickerView {
//            return dataForPicker.morning[row]
//        } else if pickerView == noonPickerView {
//            return dataForPicker.noon[row]
//        } else {
//            return dataForPicker.evening[row]
//        }
//    }
//}
