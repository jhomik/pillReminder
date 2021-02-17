//
//  NewMedicationSettingsViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import UserNotifications

final class NewMedicationSettingsViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var newMedicationView = NewMedicationSettingsView(viewModel: viewModel)
    lazy private var viewModel = NewMedicationViewModel(firebaseManagerEvents: firebaseManager)
    
    private let pillModel = PillModel()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    private(set) var activityIndicator = UIActivityIndicatorView()
    
    override func loadView() {
        self.view = newMedicationView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        createDismisKeyboardTapGesture()
        viewModel.newMedicationDelegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveSettings() {
        let medicationToSave = UserMedicationDetailModel(medicationToSave: newMedicationView)
        view.endEditing(true)
        
        if medicationToSave.anyEmpty {
            textFieldShaker(newMedicationView.nameTextField, newMedicationView.capacityTextField, newMedicationView.frequencyTextField, newMedicationView.howManyTimesTextField, newMedicationView.dosageTextField, newMedicationView.whatTimeOnceADayTextField)
            
        } else if (medicationToSave.whatTimeTwiceRow.isEmpty && !newMedicationView.whatTimeTwiceADayTextField.isHidden) || (medicationToSave.whatTimeThreeRow.isEmpty && !newMedicationView.whatTimeThreeTimesADayTextField.isHidden) {
            textFieldShaker(newMedicationView.whatTimeTwiceADayTextField, newMedicationView.whatTimeThreeTimesADayTextField)
        
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
            self.showLoadingSpinner(with: containerView, spinner: activityIndicator)
            viewModel.saveNewMedicationToFirebase(data: imageData, medicationDetail: medicationToSave) { (model) in
                self.newMedicationView.setSchedule(medicationModel: model)
                self.dismissLoadingSpinner(with: self.containerView, spinner: self.activityIndicator)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func configureImagePickerController() {
        view.endEditing(true)
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

extension NewMedicationSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let compressionQualityValue: CGFloat = 0.1
        
        guard let image = info[.originalImage] as? UIImage else { return }
        newMedicationView.medicationImage.image = image
        
        if let uploadData = image.jpegData(compressionQuality: compressionQualityValue) {
            imageData = uploadData
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewMedicationSettingsViewController: NewMedicationEventDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
