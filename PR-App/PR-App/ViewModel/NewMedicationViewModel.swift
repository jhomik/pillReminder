//
//  NewMedicationViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 07/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol NewMedicationCellDelegate {
    func addNewMedicationCell(pillName: String, capacity: String, dose: String, cellImageUrl: String)
}

final class NewMedicationViewModel {
    
    private let firebaseManager = FirebaseManager()
    var addCellDelegate: NewMedicationCellDelegate?
    
    func saveNewMedicationToFirebase(data: Data, pillName: String, capacity: String, dose: String, completion: @escaping () -> Void) {
        firebaseManager.saveImageToStorage(cellImage: data) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
                self.firebaseManager.saveUserMedicationDetail(pillName: pillName, capacity: capacity, dose: dose, cellImage: url)
                self.addCellDelegate?.addNewMedicationCell(pillName: pillName, capacity: capacity, dose: dose, cellImageUrl: url)
                completion()
            }
        }
    }
}
