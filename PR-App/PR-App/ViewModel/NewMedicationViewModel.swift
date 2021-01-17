//
//  NewMedicationViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 07/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class NewMedicationViewModel {
    
    private let firebaseManager = FirebaseManager()
    
    func saveNewMedicationToFirebase(data: Data, medicationDetail: UserMedicationDetailModel?, completion: @escaping () -> Void) {
        if !data.isEmpty {
            print("full data: \(data)")
            firebaseManager.saveImageToStorage(cellImage: data) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                  self.firebaseManager.saveUserMedicationDetail(cellImage: url, medicationDetail: medicationDetail)
                }
                completion()
            }
        } else {
            print("empty data: \(data)")
            self.firebaseManager.saveUserMedicationDetail(cellImage: nil, medicationDetail: medicationDetail)
            completion()
        }
    }
}
