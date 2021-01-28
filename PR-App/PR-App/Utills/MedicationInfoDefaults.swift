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
        case row, date, leftPill
        func make(for medicationID: String) -> String {
            return self.rawValue + "_" + medicationID
        }
    }
    let userDefaults: UserDefaults
    let medsID: String
    
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard, medsID: String = "") {
        self.userDefaults = userDefaults
        self.medsID = medsID
    }
    
    // MARK: - API
    func storeLeftPill(value: String) {
        saveValue(forKey: .leftPill, value: value, medicationID: medsID)
    }
    
    func storeRowInfo(row: Int) {
        saveValue(forKey: .row, value: row, medicationID: medsID)
    }
    
    func storeDateInfo(date: Date) {
        saveValue(forKey: .date, value: date, medicationID: medsID)
    }
    
    func getLeftPillInfo() -> String? {
        let leftPill: String? = readValue(forKey: .leftPill, medicationID: medsID)
        
        return leftPill
    }
    
    func getRowInfo() -> Int? {
        let row: Int? = readValue(forKey: .row, medicationID: medsID)
        
        return row
    }
    
    func getDateInfo() -> Date? {
        let date: Date? = readValue(forKey: .date, medicationID: medsID)
        
        return date
    }
    
    func removeUserInfo() {
        Key.allCases.map { $0.make(for: medsID) }.forEach { key in userDefaults.removeObject(forKey: key) }
    }
    
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, medicationID: String) {
        userDefaults.set(value, forKey: key.make(for: medicationID))
    }
    private func readValue<T>(forKey key: Key, medicationID: String) -> T? {
        return userDefaults.value(forKey: key.make(for: medicationID)) as? T
    }
}
