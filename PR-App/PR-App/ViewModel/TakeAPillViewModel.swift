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
    var userDefaults: MedicationInfoDefaults
    
    var leftCapacity: String? {
        return userDefaults.getLeftPillInfo(medicationModel: medications)
    }
    
    weak var takeAPillDelegate: TakeAPillEventDelegate?
    
    init(userDefaults: MedicationInfoDefaults) {
        self.userDefaults = userDefaults
    }
    
    func decreasePillValue() {
        guard var newValue = Double(leftCapacity ?? ""), let medication = medications else { return }
        
        if medication.dosage == pillModel.dosage[0] {
            newValue -= 1
        } else if medication.dosage == pillModel.dosage[1] {
            newValue -= 0.5
        } else {
            newValue -= 0.25
        }
        userDefaults.storeLeftPill(value: String("\(newValue.clean)"), medicationModel: medication)
    }
}
