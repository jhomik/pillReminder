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
    private let firebaseManager = FirebaseManager()

    var medications: UserMedicationDetailModel?
    
    weak var buttonTappedDelegate: EditButtonEventDelegate?
    
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
