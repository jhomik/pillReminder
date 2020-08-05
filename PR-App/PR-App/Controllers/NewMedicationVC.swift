//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol NewMedicationCellDelegate {
    func addNewMedicationCell()
}

final class NewMedicationVC: UIViewController {
    
    var delegate: NewMedicationCellDelegate?
    private let newMedicationView = NewMedicationView()
    private let tableView = UITableView()
    private let viewModel = PillModelViewModel()
    private(set) var newData = UserMedicationDetailModel()
    private(set) var imageData = Data()
    
    
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
        
        self.firebaseManager.savingImageToStorage(cellImage: self.imageData) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let url):
                guard let name = self.newMedicationView.nameTextField.text, let capacity = self.newMedicationView.capacityTextField.text, let dose = self.newMedicationView.doseTextField.text else { return }
                
                self.newData = UserMedicationDetailModel(pillName: name, capacity: capacity, dose: dose)
                
                self.firebaseManager.savingUserMedicationDetail(pillName: self.newData.pillName, capacity: self.newData.capacity, dose: self.newData.dose) { (result) in
                    switch result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                self.newData = UserMedicationDetailModel(cellImage: url)
            }
        }
        self.dismiss(animated: true) {
            self.delegate?.addNewMedicationCell()
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
        newMedicationView.pillImage.image = image
        
        guard let imageFB = image?.pngData() else { return }
        imageData.append(imageFB)
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewMedicationVC: UserMedicationDetailDelegate {
    func imagePickerEvent() {
        configureImagePickerController()
    }
}
