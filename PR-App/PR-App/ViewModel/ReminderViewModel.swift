//
//  ReminderViewModel.swift
//  PillReminder
//
//  Created by Jakub Homik on 29/11/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol ReminderViewEventDelegate: AnyObject {
    func reloadReminders()
}

final class ReminderViewModel {
    
    private let firebaseManager = FirebaseManager()
    private(set) var reminders: [UserMedicationDetailModel] = []
    weak var reminderEvent: ReminderViewEventDelegate?
    
    func downloadReminders() {
        firebaseManager.downloadMedicationInfo { [weak self] (result) in
            self?.reminders = result
            self?.reminderEvent?.reloadReminders()
        }
    }
}
