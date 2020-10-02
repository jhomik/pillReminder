//
//  CurrentMedicationSettingsViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 13/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol PassMedicationDelegate: AnyObject {
    func passMedication(medication: UserMedicationDetailModel)
}

final class CurrentMedicationSettingsViewController: UIViewController {
    
    let reuseId = "CurrentMedicationCell"
    private let userMedicationSettingView = CurrentMedicationSettingsView()
    private let tableView = UITableView()
    private let viewModel = CurrentMedicationSettingsViewModel()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    private let medicationView = UserMedicationDetailView()
    private var firebaseManager = FirebaseManager()
    var medications: UserMedicationDetailModel? {
        didSet {
            updateTextFieldsToChange()
        }
    }
    weak var delegate: PassMedicationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        createDismisKeyboardTapGesture()
        updateTextFieldsToChange()
        userMedicationSettingView.delegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func updateTextFieldsToChange() {
        guard let medication = medications else { return }
        self.userMedicationSettingView.medicationsToChange = medication
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateSettings))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func updateSettings() {
        view.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let name = self.userMedicationSettingView.nameTextField.text, let capacity = self.userMedicationSettingView.capacityTextField.text, let dose = self.userMedicationSettingView.doseTextField.text, var meds = medications else { return }
        
        if name.isEmpty || capacity.isEmpty || dose.isEmpty {
            textFieldsShaker(inputFields: [userMedicationSettingView.nameTextField, userMedicationSettingView.capacityTextField, userMedicationSettingView.doseTextField])
        } else {
            self.showLoadingSpinner(with: containerView)
            meds.pillName = name
            meds.capacity = capacity
            meds.dose = dose
            delegate?.passMedication(medication: meds)
            viewModel.updateMedicationInfo(data: imageData, pillName: name, capacity: capacity, dose: dose, childId: meds.id) {
                self.dismissLoadingSpinner(with: self.containerView)
                self.updateTextFieldsToChange()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func configureImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: Alerts.photoSource, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Alerts.camera, style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showUserAlert(message: Errors.cameraNotAvailable, withTime: nil, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: Alerts.photoLibrary, style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: Alerts.cancel, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureMedicationView() {
        let leadingAndTrailingAnchorConstants: CGFloat = 20
        
        view.addSubview(userMedicationSettingView)
        
        NSLayoutConstraint.activate([
            userMedicationSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userMedicationSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAndTrailingAnchorConstants),
            userMedicationSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingAndTrailingAnchorConstants),
            userMedicationSettingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CurrentMedicationSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let compressionQualityValue: CGFloat = 0.1
        
        let image = info[.originalImage] as? UIImage
        userMedicationSettingView.medicationImageView.image = image
        
        if let uploadData = image?.jpegData(compressionQuality: compressionQualityValue) {
            imageData = uploadData
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CurrentMedicationSettingsViewController: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
