//
//  ReminderForMedicationViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class ReminderForMedicationViewController: UIViewController {
    
    private var tableView = UITableView()
    private let viewModel = ReminderViewModel()
    private(set) var reminders: [UserMedicationDetailModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureReminderForMedicationVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadReminders()
    }
    
    private func configureReminderForMedicationVC() {
        title = Constants.reminder
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReminderCell.self, forCellReuseIdentifier: Constants.reminderCellId)
    }
    
    func downloadReminders() {
        viewModel.downloadMedicationInfo { [weak self] (result) in
            guard let self = self else { return }
            self.reminders = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ReminderForMedicationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reminderCellId, for: indexPath) as? ReminderCell else { return UITableViewCell() }
        cell.reminderModel = reminders[indexPath.row]
        return cell
    }
}
