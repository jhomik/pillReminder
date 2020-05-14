//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationVC: UIViewController {
    
    var testMedicine = Medicine(name: "Adderall", quantity: 2, dose: 2, remindMeToTake: true, quantityInBottle: 60, remindMeToRefill: true)
    
    var medicineImage   : UIImageView!
    var medicineName    : StandardLabel!
    var companyName     : StandardLabel!
    
    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureTableView()
        configureNavBar()
    }
    

    private func configure() {
        view.backgroundColor = Constants.backgroundColor
        medicineImage = UIImageView(image: UIImage(named: "placeholderImage"))
        medicineImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medicineImage)
        
        medicineName = StandardLabel()
        medicineName.text = "Placeholder Name"
        view.addSubview(medicineName)
        
        NSLayoutConstraint.activate([
            medicineImage.widthAnchor.constraint(equalToConstant: 200),
            medicineImage.heightAnchor.constraint(equalToConstant: 150),
            medicineImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            medicineImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            medicineName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            medicineName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            medicineName.heightAnchor.constraint(equalToConstant: 40),
            medicineName.topAnchor.constraint(equalTo: medicineImage.bottomAnchor, constant: 10)
            
        ])
        
    }
    
    
    private func configureTableView() {
        tableView                                           = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView                           = UIView()
        tableView.delegate                                  = self
        tableView.dataSource                                = self
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: InputTableViewCell.reuseID)
        tableView.register(CheckBoxTableViewCell.self, forCellReuseIdentifier: CheckBoxTableViewCell.reuseID)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: medicineName.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.plusCircle, style: .done, target: self, action: #selector(save))
    }
    
    @objc private func save() {
        print("clicky")
    }
    
    @objc private func buttonPress() {
        print("pressed")
    }
}

extension NewMedicationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.reuseID) as! InputTableViewCell
        let checkBoxCell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.reuseID) as! CheckBoxTableViewCell
        checkBoxCell.checkBoxButton.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            inputCell.set(text: "Quantity")
            inputCell.setInput(data: testMedicine.quantity)
            return inputCell
        case (0,1):
            inputCell.set(text: "Dose")
            inputCell.setInput(data: testMedicine.dose)
            return inputCell
        case (0,2):
            checkBoxCell.set(text: "Remind Me")
            return checkBoxCell
        case (1,0):
            inputCell.set(text: "Quantity Per Bottle")
            inputCell.setInput(data: testMedicine.quantityInBottle)
            return inputCell
        case (1,1):
            checkBoxCell.set(text: "Remind Me")
            return checkBoxCell
        default:
            return inputCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = HeaderView()
        switch section {
        case 0:
        title.title.text = "Dosage"
        case 1:
            title.title.text = "Refill Info"
        default:
            return nil
        }
        return title
    }
}
