//
//  AddNewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 22/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailVC: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let medicationView = UserMedicationDetailView()
    private let dosageMedicationView = DosageMedicationDetailView()
    private let editButton = CustomButton(text: Constants.changeSettings)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureMedicationView()
        configureDoseAndCapacityView()
        configureEditButton()
        medicationView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        firebaseManager.observeMedicationInfo { (result) in
            switch result {
            case .success(let data):
                self.medicationView.updatePillNameValue(data.pillName)
                self.medicationView.updatePackageCapacityValue(data.capacity)
                self.medicationView.updatePillDoseValue(data.dose)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureMedicationView() {
        view.addSubview(medicationView)
        
        NSLayoutConstraint.activate([
            medicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            medicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            medicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            medicationView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func configureImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            imagePicker.sourceType = .camera
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func configureDoseAndCapacityView() {
        view.addSubview(dosageMedicationView)
        
        NSLayoutConstraint.activate([
            dosageMedicationView.topAnchor.constraint(equalTo: medicationView.bottomAnchor, constant: 30),
            dosageMedicationView.leadingAnchor.constraint(equalTo: medicationView.leadingAnchor),
            dosageMedicationView.trailingAnchor.constraint(equalTo: medicationView.trailingAnchor),
            dosageMedicationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureEditButton() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: dosageMedicationView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: dosageMedicationView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func editButtonTapped() {
        let newMedicationVC = NewMedicationVC()
        present(UINavigationController(rootViewController: newMedicationVC), animated: true)
    }
}

extension UserMedicationDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        medicationView.pillImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UserMedicationDetailVC: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
