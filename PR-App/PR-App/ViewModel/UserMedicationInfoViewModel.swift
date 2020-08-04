//
//  UserMedicationInfoViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 28/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class UserMedicationInfoViewModel {
    
    private var model = UserMedicationDetailModel()
    
    var pillName: String {
        return model.pillName
    }
    
    var capacity: String {
        return model.capacity
    }
    
    var dose: String {
        return model.dose
    }
    

}
