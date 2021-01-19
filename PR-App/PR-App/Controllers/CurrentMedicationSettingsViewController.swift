//
//  CurrentMedicationSettingsViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 13/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

protocol PopViewControllerDelegate: AnyObject {
    func popViewController()
}

final class CurrentMedicationSettingsViewController: UIViewController {
    
    private let currentMedicationSettingsView = CurrentMedicationSettingsView()
    private let tableView = UITableView()
    private let viewModel = CurrentMedicationSettingsViewModel()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
//    private let medicationView = UserMedicationDetailView()
    var medications: UserMedicationDetailModel? {
        didSet {
            updateTextFieldsToChange()
        }
    }
    weak var popViewDelegate: PopViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        createDismisKeyboardTapGesture()
        currentMedicationSettingsView.delegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
        self.isModalInPresentation = true
    }
    
    private func updateTextFieldsToChange() {
        guard let medication = medications else { return }
        self.currentMedicationSettingsView.medicationsToChange = medication
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateSettings() {
        guard let meds = medications, let userId = meds.userIdentifier, let cellImage = meds.cellImage else { return }
        let medicationToUpdate = UserMedicationDetailModel(userIdentifier: userId, medicationToSave: currentMedicationSettingsView)
        
        view.endEditing(true)
        
        if medicationToUpdate.anyEmpty {
            textFieldShaker(currentMedicationSettingsView.nameTextField, currentMedicationSettingsView.capacityTextField, currentMedicationSettingsView.doseTextField, currentMedicationSettingsView.frequencyTextField, currentMedicationSettingsView.howManyTimesTextField, currentMedicationSettingsView.dosageTextField)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
//            self.showLoadingSpinner(with: containerView)
            if !imageData.isEmpty {
                viewModel.removeImageFromStorage(url: cellImage)
            }
            viewModel.updateMedicationInfo(data: imageData, medicationDetail: medicationToUpdate, completion: {
//                self.dismissLoadingSpinner(with: self.containerView)
                self.updateTextFieldsToChange()
                self.dismiss(animated: true) {
                    self.popViewDelegate?.popViewController()
                }
                self.currentMedicationSettingsView.setSchedule()
            })
        }
    }
    
    private func configureImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: Alerts.photoSource, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Alerts.camera, style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showUserAlert(message: Errors.cameraNotAvailable, withTime: nil, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: Alerts.photoLibrary, style: .default, handler: { (_) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: Alerts.cancel, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureMedicationView() {
        let leadingAndTrailingAnchorConstants: CGFloat = 20
        
        view.addSubview(currentMedicationSettingsView)
        
        currentMedicationSettingsView.snp.makeConstraints { (make) in
            make.leading.equalTo(leadingAndTrailingAnchorConstants)
            make.trailing.equalTo(-leadingAndTrailingAnchorConstants)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CurrentMedicationSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let compressionQualityValue: CGFloat = 0.1
        
        let image = info[.originalImage] as? UIImage
        currentMedicationSettingsView.currentMedicationImage.image = image
        
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
