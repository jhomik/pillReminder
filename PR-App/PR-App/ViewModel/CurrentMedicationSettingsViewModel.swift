//
//  CurrentMedicationSettingsViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 26/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class CurrentMedicationSettingsViewModel {
    
    var pillModel = PillModel()
    private let firebaseManager = FirebaseManager()
    
    func updateMedicationInfo(data: Data, pillName: String, capacity: String, dose: String, completion: @escaping () -> Void) {
           firebaseManager.saveImageToStorage(cellImage: data) { (result) in
               switch result {
               case .failure(let error):
                   print(error.localizedDescription)
               case .success(let url):
                guard self.firebaseManager.updateMedicationInfo(pillName: pillName, capacity: capacity, dose: dose, cellImage: url) != nil else {
                       completion()
                       return
                   }
                   completion()
               }
           }
       }
    
}
