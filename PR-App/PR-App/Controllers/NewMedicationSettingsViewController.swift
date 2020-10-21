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
    
    private let newMedicationView = NewMedicationSettingsView()
    private var firebaseManager = FirebaseManager()
    private var viewModel = NewMedicationViewModel()
    private let tableView = UITableView()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    
    
    init(viewModel: NewMedicationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        createDismisKeyboardTapGesture()
        newMedicationView.delegate = self
        
    }
    
    private func scheduleTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                self.scheduleNotification()
                print("test")
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Take a Pill"
        content.body = "It's time to take a Metocard pill"
        content.sound = .default
        
        let target = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: target), repeats: false)
        
        let request = UNNotificationRequest(identifier: "someID", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("something went wrong")
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.backgroundColor
        self.isModalInPresentation = true
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSettings))
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelSettings() {
        UserDefaults.standard.removeObject(forKey: "frequencyRow")
        UserDefaults.standard.removeObject(forKey: "howManyTimesPerdDayRow")
        UserDefaults.standard.removeObject(forKey: "dosageRow")
        scheduleTest()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveSettings() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        view.endEditing(true)
        guard let name = self.newMedicationView.nameTextField.text, let capacity = self.newMedicationView.capacityTextField.text, let dose = self.newMedicationView.doseTextField.text, let frequency = self.newMedicationView.frequencyTextField.text, let howManyTimesPerDay = self.newMedicationView.howManyTimesTextField.text, let dosage = self.newMedicationView.dosageTextField.text else { return }
        
        if name.isEmpty || capacity.isEmpty || dose.isEmpty || frequency.isEmpty || howManyTimesPerDay.isEmpty || dosage.isEmpty {
            textFieldShaker(newMedicationView.nameTextField, newMedicationView.capacityTextField, newMedicationView.doseTextField,newMedicationView.frequencyTextField, newMedicationView.howManyTimesTextField, newMedicationView.dosageTextField)
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
            self.showLoadingSpinner(with: containerView)
            viewModel.saveNewMedicationToFirebase(data: imageData, pillName: name, capacity: capacity, dose: dose, frequency: frequency, howManyTimesPerDay: howManyTimesPerDay, dosage: dosage) {
                self.dismissLoadingSpinner(with: self.containerView)
                self.dismiss(animated: true, completion: nil)
                appDelegate?.scheduleNotification(pillOfTheDay: .first, textField: self.newMedicationView.whatTimeOnceADayTextField, identifier: Constants.onceADayNotificationIdentifier, pillName: name, time: self.newMedicationView.onceADayDatePickerView.date)
                appDelegate?.scheduleNotification(pillOfTheDay: .second, textField: self.newMedicationView.whatTimeTwiceADayTextField, identifier: Constants.twiceADayNotificationIdentifier, pillName: name, time: self.newMedicationView.twiceADayDatePickerView.date)
                appDelegate?.scheduleNotification(pillOfTheDay: .last, textField: self.newMedicationView.whatTimeThreeTimesADayTextField, identifier: Constants.threeTimesADayNotificationIdentifier, pillName: name, time: self.newMedicationView.threeTimesADayDatePickerView.date)
            }
            
            UserDefaults.standard.removeObject(forKey: "frequencyRow")
            UserDefaults.standard.removeObject(forKey: "howManyTimesPerdDayRow")
            UserDefaults.standard.removeObject(forKey: "dosageRow")
        }
    }
    
    private func configureImagePickerController() {
        view.endEditing(true)
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
        
        view.addSubview(newMedicationView)
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAndTrailingAnchorConstants),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingAndTrailingAnchorConstants),
            newMedicationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NewMedicationSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let compressionQualityValue: CGFloat = 0.1
        
        guard let image = info[.originalImage] as? UIImage else { return }
        newMedicationView.medicationImage.image = image
        
        if let uploadData = image.jpegData(compressionQuality: compressionQualityValue) {
            imageData = uploadData
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewMedicationSettingsViewController: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
