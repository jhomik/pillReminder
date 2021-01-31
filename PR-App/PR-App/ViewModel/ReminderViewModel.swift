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
    
    weak var firebaseManagerEvents: FirebaseManagerEvents?
    private(set) var reminders: [UserMedicationDetailModel] = []
    weak var reminderEvent: ReminderViewEventDelegate?
    
    init(firebaseManagerEvents: FirebaseManagerEvents) {
        self.firebaseManagerEvents = firebaseManagerEvents
    }
    
    func downloadReminders() {
        firebaseManagerEvents?.downloadMedicationInfo { [weak self] (result) in
            self?.reminders = result
            self?.reminderEvent?.reloadReminders()
        }
    }
}
