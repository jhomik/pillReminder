//
//  UserMedicationDetailModel.swift
//  PR-App
//
//  Created by Jakub Homik on 30/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct UserMedicationDetailModel {
    var userIdentifier: String?
    var pillName: String
    var capacity: String
    var dose: String
    var cellImage: String?
    var frequency: String
    var howManyTimesPerDay: String
    var dosage: String
    
    var anyEmpty: Bool {
        return pillName.isEmpty || capacity.isEmpty || dose.isEmpty || frequency.isEmpty || howManyTimesPerDay.isEmpty || dosage.isEmpty
    }
    
    init(userIdentifier: String, dictionary: [String: AnyObject]) {
        self.userIdentifier = userIdentifier
        self.pillName = dictionary["pillName"] as? String ?? ""
        self.capacity = dictionary["capacity"] as? String ?? ""
        self.dose = dictionary["dose"] as? String ?? ""
        self.cellImage = dictionary["cellImage"] as? String ?? ""
        self.frequency = dictionary["frequency"] as? String ?? ""
        self.howManyTimesPerDay = dictionary["howManyTimesPerDay"] as? String ?? ""
        self.dosage = dictionary["dosage"] as? String ?? ""
    }
    
    init(medicationToSave: NewMedicationSettingsView?) {
        self.pillName = medicationToSave?.nameTextField.text ?? ""
        self.capacity = medicationToSave?.capacityTextField.text ?? ""
        self.dose = medicationToSave?.doseTextField.text ?? ""
        self.frequency = medicationToSave?.frequencyTextField.text ?? ""
        self.howManyTimesPerDay = medicationToSave?.howManyTimesTextField.text ?? ""
        self.dosage = medicationToSave?.dosageTextField.text ?? ""
    }
    
    init(medicationToSave: CurrentMedicationSettingsView?) {
        self.pillName = medicationToSave?.nameTextField.text ?? ""
        self.capacity = medicationToSave?.capacityTextField.text ?? ""
        self.dose = medicationToSave?.doseTextField.text ?? ""
        self.frequency = medicationToSave?.frequencyTextField.text ?? ""
        self.howManyTimesPerDay = medicationToSave?.howManyTimesTextField.text ?? ""
        self.dosage = medicationToSave?.dosageTextField.text ?? ""
    }
}
