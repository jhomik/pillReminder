//
//  MedicationInfoDefaults.swift
//  PillReminder
//
//  Created by Jakub Homik on 26/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import Foundation

class MedicationInfoDefaults {
    enum Key: String, CaseIterable {
        case leftPill
        func make(for medicationID: String) -> String {
            return self.rawValue + "_" + medicationID
        }
    }
    
    let userDefaults: UserDefaults
    
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - API
    func storeLeftPill(value: String, medicationModel: UserMedicationDetailModel?) {
        saveValue(forKey: .leftPill, value: value, medicationModel: medicationModel?.userIdentifier ?? "")
    }
    
    func getLeftPillInfo(medicationModel: UserMedicationDetailModel?) -> String? {
        let leftPill: String? = readValue(forKey: .leftPill, medicationModel: medicationModel?.userIdentifier ?? "")
        
        return leftPill
    }
    
    func removeUserInfo(medsID: String) {
        Key.allCases.map { $0.make(for: medsID) }.forEach { key in userDefaults.removeObject(forKey: key) }
    }
    
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, medicationModel: String) {
        userDefaults.set(value, forKey: key.make(for: medicationModel))
    }
    private func readValue<T>(forKey key: Key, medicationModel: String) -> T? {
        return userDefaults.value(forKey: key.make(for: medicationModel)) as? T
    }
}
