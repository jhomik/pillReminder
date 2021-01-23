//
//  ReminderForMedicationViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class ReminderForMedicationViewController: UIViewController {
   
    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var viewModel = ReminderViewModel(firebaseManagerEvents: firebaseManager)
    lazy private(set) var reminderForMedicationView = ReminderForMedicationView(viewModel: viewModel)

    override func loadView() {
        self.view = reminderForMedicationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureReminderForMedicationVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.downloadReminders()
    }
    
    private func configureReminderForMedicationVC() {
        title = Constants.reminder
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
