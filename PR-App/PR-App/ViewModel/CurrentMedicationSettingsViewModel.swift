//
//  CurrentMedicationSettingsViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 26/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class CurrentMedicationSettingsViewModel {
    
//    var pillModel = PillModel()
    private let firebaseManager = FirebaseManager()
    
    func updateMedicationInfo(data: Data, medicationDetail: UserMedicationDetailModel, completion: @escaping () -> Void) {
        if !data.isEmpty {
            firebaseManager.saveImageToStorage(cellImage: data) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    self.firebaseManager.updateMedicationInfo(cellImage: url, medicationDetail: medicationDetail)
                }
                completion()
            }
        } else {
            self.firebaseManager.updateMedicationInfo(cellImage: nil, medicationDetail: medicationDetail)
        }
        completion()
    }
    
    func removeImageFromStorage(url: String) {
        firebaseManager.removeImageFromStorage(cellImage: url)
    }
}
