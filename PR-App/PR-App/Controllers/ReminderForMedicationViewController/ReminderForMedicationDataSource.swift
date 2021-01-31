//
//  ReminderForMedicationDataSource.swift
//  PillReminder
//
//  Created by Jakub Homik on 21/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit

final class ReminderForMedicationDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: ReminderViewModel
    
    init(viewModel: ReminderViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reminderCellId, for: indexPath) as? ReminderCell else { return UITableViewCell() }
        cell.reminderModel = viewModel.reminders[indexPath.row]
        return cell
    }
}
