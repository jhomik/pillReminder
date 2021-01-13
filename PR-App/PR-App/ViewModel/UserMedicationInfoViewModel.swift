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
    
    private(set) var medications: [UserMedicationDetailModel] = [] {
        didSet {
            
        }
    }
    
//    func cellForItem(_ indexPath: IndexPath) {
//        let title = medications[indexPath.item].pillName
//        if medications.indices.contains(indexPath.item) == true {
//            guard let urlImage = medications[indexPath.item].cellImage else { return }
//            
//        }
//    }

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
    
    func downloadMedicationInfo(completion: @escaping ([UserMedicationDetailModel]) -> Void) {
        firebaseManager.downloadMedicationInfo { (result) in
            completion(result)
        }
    }
    func removeDataFromFirebase(model: UserMedicationDetailModel) {
        firebaseManager.removeDataFromFirebase(model: model)
    }
}
