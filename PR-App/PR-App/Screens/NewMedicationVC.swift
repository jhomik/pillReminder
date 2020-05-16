//
//  NewMedicationVC.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class NewMedicationVC: UIViewController {
    
    var testMedicine = Medicine(name: "Adderall", quantity: 2, dose: 2, remindMeToTake: true, quantityInBottle: 60, quantityOnHand: 60, remindMeToRefill: true, morning: 2, midDay: 2, evening: 2)
    
    var medicineImage   : UIImageView!
    var medicineName    : StandardLabel!
    var companyName     : StandardLabel!
    var daysLeft        : Double!
    var totalPerDay     : Double!
    
    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateNumbers(isAtStart: true)
        configure()
        configureTableView()
        configureNavBar()
        dismissKeyboard()
    }
    
    func updateNumbers(isAtStart: Bool) {
        totalPerDay = testMedicine.midDay + testMedicine.morning + testMedicine.evening
        daysLeft = testMedicine.quantityOnHand / totalPerDay
        if !isAtStart {
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! InputTableViewCell
            cell.setInput(data: daysLeft)
        }
        
        
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
        tableView.backgroundColor                           = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView                           = UIView()
        tableView.delegate                                  = self
        tableView.dataSource                                = self
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: InputTableViewCell.reuseID)
        tableView.register(CheckBoxTableViewCell.self, forCellReuseIdentifier: CheckBoxTableViewCell.reuseID)
        tableView.register(DoseScheduleCell.self, forCellReuseIdentifier: DoseScheduleCell.reuseID)
        

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: medicineName.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
    }
    
    @objc private func save() {
        print("clicky")
        
    }
    
    @objc private func buttonPress(sender: CheckBoxButton) {
        sender.set(isSelected: !sender.isSelected)
        print(sender.isSelected)
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
}

extension NewMedicationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.reuseID) as! InputTableViewCell
        inputCell.textPassBackDelegate = self
        let checkBoxCell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.reuseID) as! CheckBoxTableViewCell
        let doseScheduleCell = tableView.dequeueReusableCell(withIdentifier: DoseScheduleCell.reuseID) as! DoseScheduleCell
        doseScheduleCell.passBackFromScheduleDelegate = self
        checkBoxCell.checkBoxButton.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            inputCell.set(text: "Daily Taken")
            inputCell.setInput(data: totalPerDay)
            inputCell.inputField.isUserInteractionEnabled = false
            return inputCell
        case (0,1):
            doseScheduleCell.set(morning: testMedicine.morning, midDay: testMedicine.midDay, evening: testMedicine.evening)
            return doseScheduleCell
        case (0,2):
            checkBoxCell.set(text: "Remind Me")
            checkBoxCell.checkBoxButton.set(isSelected: testMedicine.remindMeToTake)
            return checkBoxCell
        case (1,0):
            inputCell.set(text: "Quantity Per Bottle")
            inputCell.setInput(data: testMedicine.quantityInBottle)
            return inputCell
        case (1,1):
            inputCell.set(text: "Quantity Remaining")
            inputCell.setInput(data: testMedicine.quantityOnHand)
            return inputCell
        case (1,2):
            inputCell.set(text: "Days Until Empty")
            inputCell.setInput(data: daysLeft)
            inputCell.inputField.isUserInteractionEnabled = false
            return inputCell
        case (1,3):
            checkBoxCell.set(text: "Remind Me")
            checkBoxCell.checkBoxButton.set(isSelected: testMedicine.remindMeToRefill)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,1):
            return (UIScreen.main.bounds.width / 4) + 15
        default:
            return (UIScreen.main.bounds.width / 8) + 10
        }
    }
}

extension NewMedicationVC : TextPassBackDelegate, PassBackFromScheduleDelegate {
    func updateFromDoseSchedule(updatedValue: Double, tag: Int) {
        switch tag {
        case 1:
            testMedicine.morning = updatedValue
        case 2:
            testMedicine.midDay = updatedValue
        case 3:
            testMedicine.evening = updatedValue
        default:
            return
        }
        updateNumbers(isAtStart: false)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func update(updatedValue: Double, tag: Int) {
        testMedicine.quantityOnHand = updatedValue
        updateNumbers(isAtStart: false)
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .none)
    }
}
