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
    private let firebaseManager = FirebaseManager()
    
    //    var pillName: String {
    //        return model.pillName
    //    }
    //
    //    var capacity: String {
    //        return model.capacity
    //    }
    //
    //    var dose: String {
    //        return model.dose
    //    }
    //
    //    var cellImage: String {
    //        return model.cellImage
    //    }
    
    func observeUserName(completion: @escaping (String) -> Void) {
        firebaseManager.observeUserName() { result in
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
}

