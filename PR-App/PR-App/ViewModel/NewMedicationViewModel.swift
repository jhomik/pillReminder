//
//  NewMedicationViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 07/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol NewMedicationEventDelegate: AnyObject {
    func imagePickerEvent()
}

final class NewMedicationViewModel {
    
    weak var firebaseManagerEvents: FirebaseManagerEvents?
    weak var newMedicationDelegate: NewMedicationEventDelegate?
    
    private(set) var medications: UserMedicationDetailModel?
    
    init(firebaseManagerEvents: FirebaseManagerEvents) {
        self.firebaseManagerEvents = firebaseManagerEvents
    }
    
    func saveNewMedicationToFirebase(data: Data, medicationDetail: UserMedicationDetailModel?, completion: @escaping (UserMedicationDetailModel) -> Void) {
        if !data.isEmpty {
            print("full data: \(data)")
            firebaseManagerEvents?.saveImageToStorage(cellImage: data) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    self.firebaseManagerEvents?.saveUserMedicationDetail(cellImage: url, medicationDetail: medicationDetail, completion: completion)
                }
            }
        } else {
            print("empty data: \(data)")
            self.firebaseManagerEvents?.saveUserMedicationDetail(cellImage: nil, medicationDetail: medicationDetail, completion: completion)
        }
    }
    
    func setCapacityText(_ text: String?) -> String {
        guard let text = text, let amount = Int(text) else { return "" }
        if amount <= 1 {
            return Constants.pill
        } else {
            return Constants.pills
        }
    }
    
    func setFilterForTextField(text: inout String?) {
        if let filterText = text, let intText = Int(filterText) {
            text = "\(intText)"
        } else {
            text = ""
        }
    }
}
