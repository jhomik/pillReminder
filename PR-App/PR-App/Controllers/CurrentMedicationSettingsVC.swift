//
//  CurrentMedicationSettingsVC.swift
//  PR-App
//
//  Created by Jakub Homik on 13/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CurrentMedicationSettingsVC: UIViewController {
    
    private let userMedicationSettingView = UserMedicationSettingsView()
    private let tableView = UITableView()
    private let viewModel = CurrentMedicationSettingsViewModel()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    private let medicationView = UserMedicationDetailView()
    private var firebaseManager = FirebaseManager()
    var medicationsToChange: UserMedicationDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        configureTableView()
        createDismisKeyboardTapGesture()
        updateTextFieldsToChange()
        configureCurrentMedicationView()
        userMedicationSettingView.delegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    func updateTextFieldsToChange() {
        guard let medication = medicationsToChange else { return }
        userMedicationSettingView.nameTextField.text = medication.pillName
        userMedicationSettingView.capacityTextField.text = medication.capacity
        userMedicationSettingView.doseTextField.text = medication.dose
        firebaseManager.downloadImage(with: medication.cellImage, imageCell: userMedicationSettingView.pillImage)
    }
    
    private func configureCurrentMedicationView() {
        userMedicationSettingView.addMedicationLbl.text = Constants.changeMedications
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func saveSettings() {
        print("update medications")
    }
    
    private func configureImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureMedicationView() {
        view.addSubview(userMedicationSettingView)
        
        NSLayoutConstraint.activate([
            userMedicationSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userMedicationSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userMedicationSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userMedicationSettingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseId)
        tableView.backgroundColor = Constants.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: userMedicationSettingView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CurrentMedicationSettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pillModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath)
        cell.textLabel?.text = viewModel.pillModel.morning[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = HeaderCellView(frame: .zero, titleLabel: viewModel.pillModel.sections[section])
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension CurrentMedicationSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        medicationView.pillImage.image = image
        
        if let uploadData = image?.jpegData(compressionQuality: 0.1) {
            imageData.append(uploadData)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CurrentMedicationSettingsVC: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
