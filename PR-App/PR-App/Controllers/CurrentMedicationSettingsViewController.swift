//
//  CurrentMedicationSettingsViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 13/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol PopViewControllerDelegate: AnyObject {
    func popViewController()
}

final class CurrentMedicationSettingsViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var currentMedicationSettingsView = CurrentMedicationSettingsView(viewModel: viewModel)
    lazy private(set) var viewModel = CurrentMedicationSettingsViewModel(firebaseManagerEvents: firebaseManager)
    
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    private(set) var activityIndicator = UIActivityIndicatorView()
    
    weak var popViewDelegate: PopViewControllerDelegate?
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func loadView() {
        self.view = currentMedicationSettingsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        createDismisKeyboardTapGesture()
        viewModel.currentMedicationDelegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
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
        guard let meds = viewModel.medications, let userId = meds.userIdentifier else { return }
        
        let medicationToUpdate = UserMedicationDetailModel(userIdentifier: userId, leftCapacity: meds.leftCapacity, medicationToSave: currentMedicationSettingsView)
        
        view.endEditing(true)
        
        if medicationToUpdate.anyEmpty {
            textFieldShaker(currentMedicationSettingsView.nameTextField, currentMedicationSettingsView.capacityTextField, currentMedicationSettingsView.frequencyTextField, currentMedicationSettingsView.howManyTimesTextField, currentMedicationSettingsView.whatTimeOnceADayTextField, currentMedicationSettingsView.whatTimeTwiceADayTextField, currentMedicationSettingsView.whatTimeThreeTimesADayTextField, currentMedicationSettingsView.dosageTextField)
            
        } else if (medicationToUpdate.whatTimeTwiceRow.isEmpty && !currentMedicationSettingsView.whatTimeTwiceADayTextField.isHidden) || (medicationToUpdate.whatTimeThreeRow.isEmpty && !currentMedicationSettingsView.whatTimeThreeTimesADayTextField.isHidden) {
    textFieldShaker(currentMedicationSettingsView.whatTimeTwiceADayTextField, currentMedicationSettingsView.whatTimeThreeTimesADayTextField)
            
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
            self.showLoadingSpinner(with: containerView, spinner: activityIndicator)
            viewModel.updateMedicationInfo(data: imageData, medicationDetail: medicationToUpdate) {
                self.appDelegate?.deletePendingNotification(medicationID: medicationToUpdate.userIdentifier)
                self.currentMedicationSettingsView.setSchedule(medicationModel: medicationToUpdate)
                self.dismissLoadingSpinner(with: self.containerView, spinner: self.activityIndicator)
                self.dismiss(animated: true) {
                    self.popViewDelegate?.popViewController()
                }
            }
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

extension CurrentMedicationSettingsViewController: CurrentMedicationEventDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
