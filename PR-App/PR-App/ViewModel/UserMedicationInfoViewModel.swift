//
//  UserMedicationInfoViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 28/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class UserMedicationInfoViewModel {
    
    private let firebaseManager = FirebaseManager()

    func setUserName(completion: @escaping (String) -> Void) {
        firebaseManager.setUserName { result in
            switch result {
            case .success(let userName):
                completion(userName)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateMedicationInfo(completion: @escaping ([UserMedicationDetailModel]) -> Void) {
        firebaseManager.downloadMedicationInfo { (result) in
            completion(result)
        }
    }
    func removeDataFromFirebase(model: UserMedicationDetailModel) {
        firebaseManager.removeDataFromFirebase(model: model)
    }
}
