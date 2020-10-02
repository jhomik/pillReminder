//
//  UserMedicationDetailModel.swift
//  PR-App
//
//  Created by Jakub Homik on 30/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct UserMedicationDetailModel {
    var id: String
    var pillName: String
    var capacity: String
    var dose: String
    var cellImage: String
    var frequency: String
    
    init(id: String, dictionary: [String: AnyObject]) {
        self.id = id
        self.pillName = dictionary["pillName"] as? String ?? ""
        self.capacity = dictionary["capacity"] as? String ?? ""
        self.dose = dictionary["dose"] as? String ?? ""
        self.cellImage = dictionary["cellImage"] as? String ?? ""
        self.frequency = dictionary["frequency"] as? String ?? ""
    }
}
