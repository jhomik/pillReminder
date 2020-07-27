//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Jakub Homik on 27/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol UpdateTextFields: AnyObject {
    func update(name: String, capacity: String, dose: String)
}

final class NewMedicationVC: UIViewController {
    
    weak var delegate: UpdateTextFields?
    private let newMedicationView = NewMedicationView()
    private let programMedicationView = ProgramMedicationView()
    private let tableView = UITableView()
    private let viewModel = PillModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavBar()
        configureMedicationView()
        configureTableView()
    }
    
    private func configureViewController() {
        view.backgroundColor = Constants.backgroundColor
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSettings))
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Constants.mainColor
    }
    
    @objc private func saveSettings() {
        delegate?.update(name: "test1", capacity: "test2", dose: "test3")
        dismiss(animated: true, completion: nil)
    }
    
    private func configureMedicationView() {
        view.addSubview(newMedicationView)
        
        NSLayoutConstraint.activate([
            newMedicationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newMedicationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newMedicationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            //            newMedicationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
