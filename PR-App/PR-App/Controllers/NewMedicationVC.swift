//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol NewMedicationCellDelegate {
    func addNewMedicationCell(with medication: MedicationInfoCellModel)
}

final class NewMedicationVC: UIViewController {
    
    var delegate: NewMedicationCellDelegate?
    private let newMedicationView = NewMedicationView()
    private let tableView = UITableView()
    private let viewModel = PillModelViewModel()
    
    private var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        configureTableView()
        createDismisKeyboardTapGesture()
        observeUserSettings()
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func observeUserSettings() {
        firebaseManager.observeMedicationInfo { (result) in
            switch result {
            case .success(let data):
                self.newMedicationView.nameTextField.text = data.pillName
                self.newMedicationView.capacityTextField.text = data.capacity
                self.newMedicationView.doseTextField.text = data.dose
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Constants.mainColor
    }
    
    @objc private func saveSettings() {
        
        // change this to be delegate and try to not accessing newMedicationView file
        
        guard let name = newMedicationView.nameTextField.text, let capacity = newMedicationView.capacityTextField.text, let dose = newMedicationView.doseTextField.text else { return }
        
        let newData = UserMedicationDetailModel(pillName: name, capacity: capacity, dose: dose)
        
        firebaseManager.savingUserMedicationDetail(pillName: newData.pillName, capacity: newData.capacity, dose: newData.dose) { (result) in
            switch result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true) {
            // add new cell with new medication
            let newMeds = MedicationInfoCellModel(image: "test2", labelName: "test2")
            self.delegate?.addNewMedicationCell(with: newMeds)
        }
    }
    
    private func configureMedicationView() {
        view.addSubview(newMedicationView)
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewMedicationCell")
        tableView.backgroundColor = Constants.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: newMedicationView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension NewMedicationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMedicationCell", for: indexPath)
        cell.textLabel?.text = viewModel.morning[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = HeaderView(frame: .zero, titleLabel: viewModel.sections[section])
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
