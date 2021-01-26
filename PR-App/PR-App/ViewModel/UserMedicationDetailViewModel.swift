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
    
    private let pillModel = PillModel()

    var medications: UserMedicationDetailModel?
    
    weak var buttonTappedDelegate: EditButtonEventDelegate?
    
    var leftCapacity: String? {
        return medications?.capacity
    }
    
    func decreasePillValue(with value: String?) {
        guard var newValue = Double(value ?? ""), let medication = medications else { return }
    
        if medication.dosage == pillModel.dosage[0] {
            newValue -= 1
        } else if medication.dosage == pillModel.dosage[1] {
            newValue -= 0.5
        } else {
            newValue -= 0.25
        }
    }
    
    func setPackageSuffixLabel(_ value: String) -> String {
        guard let amount = Int(value) else { return "" }
        
        if amount <= 1 {
            return value + Constants.pill
        } else {
            return value + Constants.pills
        }
    }
    
    func configureDoseInformations() -> String {
        if medications?.howManyTimesPerDay == pillModel.howManyTimesPerDay[0] {
            return Constants.onceADay
        } else if medications?.howManyTimesPerDay == pillModel.howManyTimesPerDay[1] {
            return Constants.twiceADay
        } else {
            return Constants.threeTimesADay
        }
    }
    
    func setPillsLeftLabel(_ value: String) -> String {
        guard let amount = Double(value) else { return "" }
        
        if amount <= 1 {
            return Constants.pillLeft + value + Constants.pill
        } else {
            return Constants.pillsLeft + value + Constants.pills
        }
    }
}
