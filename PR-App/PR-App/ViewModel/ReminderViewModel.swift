//
//  ReminderViewModel.swift
//  PillReminder
//
//  Created by Jakub Homik on 29/11/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class ReminderViewModel {
    
    private let firebaseManager = FirebaseManager()
    
    func downloadMedicationInfo(completion: @escaping ([UserMedicationDetailModel]) -> Void) {
        firebaseManager.downloadMedicationInfo { (result) in
            completion(result)
        }
    }
}
