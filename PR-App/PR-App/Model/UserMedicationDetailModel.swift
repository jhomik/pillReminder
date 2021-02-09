//
//  UserMedicationDetailModel.swift
//  PR-App
//
//  Created by Jakub Homik on 30/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct UserMedicationDetailModel: Codable {
    var userIdentifier: String?
    var pillName: String
    var capacity: String
    var leftCapacity: String
    var dose: String
    var cellImage: String?
    var frequency: String
    var howManyTimesPerDay: String
    var whatTimeOnceRow: String
    var whatTimeTwiceRow: String
    var whatTimeThreeRow: String
    var dosage: String
    
    var anyEmpty: Bool {
        return pillName.isEmpty || capacity.isEmpty || dose.isEmpty || frequency.isEmpty || howManyTimesPerDay.isEmpty || dosage.isEmpty || whatTimeOnceRow.isEmpty 
    }
    
    init(userIdentifier: String, dictionary: [String: AnyObject]) {
        self.userIdentifier = userIdentifier
        self.pillName = dictionary["pillName"] as? String ?? ""
        self.capacity = dictionary["capacity"] as? String ?? ""
        self.dose = dictionary["dose"] as? String ?? ""
        self.cellImage = dictionary["cellImage"] as? String ?? ""
        self.frequency = dictionary["frequency"] as? String ?? ""
        self.howManyTimesPerDay = dictionary["howManyTimesPerDay"] as? String ?? ""
        self.whatTimeOnceRow = dictionary["whatTimeOnceRow"] as? String ?? ""
        self.whatTimeTwiceRow = dictionary["whatTimeTwiceRow"] as? String ?? ""
        self.whatTimeThreeRow = dictionary["whatTimeThreeRow"] as? String ?? ""
        self.dosage = dictionary["dosage"] as? String ?? ""
        self.leftCapacity = dictionary["leftCapacity"] as? String ?? ""
    }
    
    init(medicationToSave: NewMedicationSettingsView?) {
        self.pillName = medicationToSave?.nameTextField.text ?? ""
        self.capacity = medicationToSave?.capacityTextField.text ?? ""
        self.dose = medicationToSave?.doseTextField.text ?? ""
        self.frequency = medicationToSave?.frequencyTextField.text ?? ""
        self.howManyTimesPerDay = medicationToSave?.howManyTimesTextField.text ?? ""
        self.whatTimeOnceRow = medicationToSave?.whatTimeOnceADayTextField.text ?? ""
        self.whatTimeTwiceRow = medicationToSave?.whatTimeTwiceADayTextField.text ?? ""
        self.whatTimeThreeRow = medicationToSave?.whatTimeThreeTimesADayTextField.text ?? ""
        self.dosage = medicationToSave?.dosageTextField.text ?? ""
        self.leftCapacity = medicationToSave?.capacityTextField.text ?? ""
    }
    
    init(userIdentifier: String, leftCapacity: String, medicationToSave: CurrentMedicationSettingsView?) {
        self.userIdentifier = userIdentifier
        self.pillName = medicationToSave?.nameTextField.text ?? ""
        self.capacity = medicationToSave?.capacityTextField.text ?? ""
        self.dose = medicationToSave?.doseTextField.text ?? ""
        self.frequency = medicationToSave?.frequencyTextField.text ?? ""
        self.howManyTimesPerDay = medicationToSave?.howManyTimesTextField.text ?? ""
        self.whatTimeOnceRow = medicationToSave?.whatTimeOnceADayTextField.text ?? ""
        self.whatTimeTwiceRow = medicationToSave?.whatTimeTwiceADayTextField.text ?? ""
        self.whatTimeThreeRow = medicationToSave?.whatTimeThreeTimesADayTextField.text ?? ""
        self.dosage = medicationToSave?.dosageTextField.text ?? ""
        self.leftCapacity = leftCapacity
    }
}
