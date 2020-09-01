//
//  CurrentMedicationSettingsViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 13/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CurrentMedicationSettingsViewController: UIViewController {
    
    let reuseId = "CurrentMedicationCell"
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
        view.backgroundColor = UIColor.backgroundColor
    }
    
    func updateTextFieldsToChange() {
        guard let medication = medicationsToChange else { return }
        userMedicationSettingView.nameTextField.text = medication.pillName
        userMedicationSettingView.capacityTextField.text = medication.capacity
        userMedicationSettingView.doseTextField.text = medication.dose
        firebaseManager.downloadImage(with: medication.cellImage, imageCell: userMedicationSettingView.medicationImage)
    }
    
    private func configureCurrentMedicationView() {
        userMedicationSettingView.addMedicationLbl.text = Constants.changeMedications
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func saveSettings() {
        print("update medications")
    }
    
    private func configureImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: PRAlerts.photoSource.rawValue, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: PRAlerts.camera.rawValue, style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showUserAlert(message: PRErrors.cameraNotAvailable.rawValue, withTime: nil, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: PRAlerts.photoLibrary.rawValue, style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: PRAlerts.cancel.rawValue, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureMedicationView() {
        let leadingAndTrailingAnchorConstants: CGFloat = 20
        let heightAnchorMultiplier: CGFloat = 0.24
        
        view.addSubview(userMedicationSettingView)
        
        NSLayoutConstraint.activate([
            userMedicationSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userMedicationSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAndTrailingAnchorConstants),
            userMedicationSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingAndTrailingAnchorConstants),
            userMedicationSettingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightAnchorMultiplier)
        ])
    }
    
    private func configureTableView() {
        let topAnchorConstant: CGFloat = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: userMedicationSettingView.bottomAnchor, constant: topAnchorConstant),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CurrentMedicationSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.pillModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
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

extension CurrentMedicationSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let compressionQualityValue: CGFloat = 0.1
        
        let image = info[.originalImage] as? UIImage
        medicationView.pillImage.image = image
        
        if let uploadData = image?.jpegData(compressionQuality: compressionQualityValue) {
            imageData.append(uploadData)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CurrentMedicationSettingsViewController: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
