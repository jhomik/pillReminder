//
//  MedicationInfoCellModel.swift
//  PR-App
//
//  Created by Jakub Homik on 30/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

struct MedicationInfoCellModel {
    var cellImage: String
    var cellTitle: String
    
    init(image: String = "test", labelName: String = "Metocard") {
        self.cellImage = image
        self.cellTitle = labelName
    }
}
