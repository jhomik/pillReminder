//
//  UserMedicationDetailViewModel.swift
//  PillReminder
//
//  Created by Jakub Homik on 15/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import Foundation

protocol EditButtonEventDelegate: AnyObject {
    func editButtonTapped()
}

final class UserMedicationDetailViewModel {
    
    weak var buttonTappedDelegate: EditButtonEventDelegate?
    
    var medications: UserMedicationDetailModel? {
        didSet {
            
        }
    }
    
    var leftCapacity: String? {
        return medications?.capacity
    }
    
    func decreasePillValue() -> String {
        guard let newValue = Double(leftCapacity ?? ""), let medication = medications else { return "" }
        if medication.dosage == "1" {
            return String(newValue - 1)
        } else if medication.dosage == "1/2" {
            return String(newValue - 0.5)
        } else {
            return String(newValue - 0.25)
        }
    }
}
