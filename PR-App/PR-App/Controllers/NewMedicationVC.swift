//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol NewMedicationCellDelegate {
    func addNewMedicationCell(pillName: String, capacity: String, dose: String, cellImageUrl: String)
}


final class NewMedicationVC: UIViewController {
    
    var addDelegate: NewMedicationCellDelegate?
    private let newMedicationView = NewMedicationView()
    private let tableView = UITableView()
    private let viewModel = PillModelViewModel()
    private(set) var imageData = Data()
    private(set) var containerView = UIView()
    private let medicationView = UserMedicationDetailView()
    private var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        configureTableView()
        createDismisKeyboardTapGesture()
        observeUserSettings()
        newMedicationView.delegate = self
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func observeUserSettings() {
        firebaseManager.downloadMedicationInfo { (result) in
            result.forEach { (data) in
                self.medicationView.updatePillNameValue(data.pillName)
                self.medicationView.updatePackageCapacityValue(data.capacity)
                self.medicationView.updatePillDoseValue(data.dose)
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
        showLoadingSpinner(with: containerView)
        firebaseManager.savingImageToStorage(cellImage: imageData) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let url):
                guard let name = self.newMedicationView.nameTextField.text, let capacity = self.newMedicationView.capacityTextField.text, let dose = self.newMedicationView.doseTextField.text else { return }
                
                self.firebaseManager.savingUserMedicationDetail(pillName: name, capacity: capacity, dose: dose, cellImage: url)
                
                self.dismissLoadingSpinner(with: self.containerView)
                self.dismiss(animated: true) {
                    self.addDelegate?.addNewMedicationCell(pillName: name, capacity: capacity, dose: dose, cellImageUrl: url)
                }
            }
        }
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
        view.addSubview(newMedicationView)
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            newMedicationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24)
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

extension NewMedicationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        if let uploadData = image?.jpegData(compressionQuality: 0.1) {
            imageData.append(uploadData)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewMedicationVC: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
