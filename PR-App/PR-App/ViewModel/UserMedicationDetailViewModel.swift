//
//  UserMedicationDetailViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 29/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

final class UserMedicationDetailViewModel {
    
    private let firebaseManager = FirebaseManager()
    private let medicationDetailView = UserMedicationDetailView()
    
    func updateMedicationInfo(completion: @escaping ([UserMedicationDetailModel]) -> Void) {
           firebaseManager.downloadMedicationInfo { (result) in
               completion(result)
           }
       }
    
}
