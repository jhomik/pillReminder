//
//  CurrentMedicationSettingsViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 26/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol CurrentMedicationEventDelegate: AnyObject {
    func imagePickerEvent()
}

final class CurrentMedicationSettingsViewModel {
    
    var medications: UserMedicationDetailModel?
    
    weak var firebaseManagerEvents: FirebaseManagerEvents?
    weak var currentMedicationDelegate: CurrentMedicationEventDelegate?
    
    init(firebaseManagerEvents: FirebaseManagerEvents) {
        self.firebaseManagerEvents = firebaseManagerEvents
    }
    
    func setFilterForTextField(text: inout String?) {
        if let filterText = text, let intText = Int(filterText) {
            text = "\(intText)"
        } else {
            text = ""
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
    
    func updateMedicationInfo(data: Data, medicationDetail: UserMedicationDetailModel, completion: @escaping () -> Void) {
        if !data.isEmpty {
            firebaseManagerEvents?.saveImageToStorage(cellImage: data) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let url):
                    if self.medications?.cellImage == "" {
                        self.firebaseManagerEvents?.updateMedicationInfo(cellImage: url, medicationDetail: medicationDetail)
                        completion()
                    } else {
                        self.removeImageFromStorage(url: self.medications?.cellImage ?? "")
                        self.firebaseManagerEvents?.updateMedicationInfo(cellImage: url, medicationDetail: medicationDetail)
                        completion()
                    }
                }
            }
        } else {
            self.firebaseManagerEvents?.updateMedicationInfo(cellImage: nil, medicationDetail: medicationDetail)
            completion()
        }
    }
    
    func removeImageFromStorage(url: String) {
        firebaseManagerEvents?.removeImageFromStorage(cellImage: url)
    }
}
