//
//  UserMedicationDetailModel.swift
//  PR-App
//
//  Created by Jakub Homik on 30/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct UserMedicationDetailModel {
    var pillName: String
    var capacity: String
    var dose: String
    var cellImage: String
    
    
    init(dictionary: [String: AnyObject]) {
        self.pillName = dictionary["pillName"] as? String ?? ""
        self.capacity = dictionary["capacity"] as? String ?? ""
        self.dose = dictionary["dose"] as? String ?? ""
        self.cellImage = dictionary["cellImage"] as? String ?? ""
    }
    
    init(pillName: String = "Tritace", capacity: String = "24 pills", dose: String = "10 mg", cellImage: String = "cellImage") {
        self.pillName = pillName
        self.capacity = capacity
        self.dose = dose
        self.cellImage = cellImage
        
    }
}
