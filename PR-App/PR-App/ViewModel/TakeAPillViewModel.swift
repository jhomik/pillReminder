//
//  TakeAPillViewModel.swift
//  PillReminder
//
//  Created by Jakub Homik on 28/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import Foundation

protocol TakeAPillEventDelegate: AnyObject {
    func onButtonTapped()
}

final class TakeAPillViewModel {
    
    var medications: UserMedicationDetailModel?
    var pillModel = PillModel()
    weak var firebaseManagerEvents: FirebaseManagerEvents?
    
    var leftCapacity: String? {
        return medications?.leftCapacity
    }
    
    weak var takeAPillDelegate: TakeAPillEventDelegate?
    
    init(firebaseManagerEvents: FirebaseManagerEvents) {
        self.firebaseManagerEvents = firebaseManagerEvents
    }
    
    func decreasePillValue(completion: () -> Void) {
        guard var newValue = Double(leftCapacity ?? ""), let medication = medications, newValue != 0 else { return }
        
        if medication.dosage == pillModel.dosage[0] {
            newValue -= 1
        } else if medication.dosage == pillModel.dosage[1] {
            newValue -= 0.5
        } else {
            newValue -= 0.25
        }
        
        firebaseManagerEvents?.updateLeftCapacity(medicationID: medications?.userIdentifier ?? "", leftCapacity: newValue.clean)
        completion()
    }
}
