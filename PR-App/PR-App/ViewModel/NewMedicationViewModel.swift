//
//  NewMedicationViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 07/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol NewMedicationCellDelegate: AnyObject {
    func addNewMedicationCell(_ model: UserMedicationDetailModel)
}

final class NewMedicationViewModel {
    
    var pillModel = PillModel()
    private let firebaseManager = FirebaseManager()
    weak var addCellDelegate: NewMedicationCellDelegate?
    
    func saveNewMedicationToFirebase(data: Data, medicationDetail: UserMedicationDetailModel?, completion: @escaping () -> Void) {
        firebaseManager.saveImageToStorage(cellImage: data) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
                guard let model = self.firebaseManager.saveUserMedicationDetail(cellImage: url, medicationDetail: medicationDetail) else {
                    completion()
                    return
                }
                self.addCellDelegate?.addNewMedicationCell(model)
                completion()
            }
        }
    }
}
