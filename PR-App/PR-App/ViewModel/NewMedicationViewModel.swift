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
    
    func saveNewMedicationToFirebase(data: Data, pillName: String, capacity: String, dose: String, frequency: String, howManyTimesPerDay: String, dosage: String, completion: @escaping () -> Void) {
        firebaseManager.saveImageToStorage(cellImage: data) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let url):
                guard let model = self.firebaseManager.saveUserMedicationDetail(pillName: pillName, capacity: capacity, dose: dose, cellImage: url, frequency: frequency, howManyTimesPerDay: howManyTimesPerDay, dosage: dosage) else {
                    completion()
                    return
                }
                
                self.addCellDelegate?.addNewMedicationCell(model)
                completion()
            }
        }
    }
    
//    func pickerDoneButtonTapped(activeTextField: UITextField) {
//        guard let textField = activeTextField else { return }
//        if textField == frequencyTextField {
//            let row = pillModel.frequency[pickerView.selectedRow(inComponent: 0)]
//            textField.text = row
//            userDefaults.set(row, forKey: "frequencyRow")
//        } else if textField == howManyTimesTextField {
//            let row = pillModel.howManyTimesPerDay[pickerView.selectedRow(inComponent: 0)]
//            textField.text = row
//            userDefaults.set(row, forKey: "howManyTimesPerdDayRow")
//            switch pickerView.selectedRow(inComponent: 0) {
//            case 0:
//                whatTimeTwiceADayTextField.isHidden = true
//                whatTimeThreeTimesADayTextField.isHidden = true
//            case 1:
//                whatTimeTwiceADayTextField.isHidden = false
//                whatTimeThreeTimesADayTextField.isHidden = true
//            case 2:
//                whatTimeTwiceADayTextField.isHidden = false
//                whatTimeThreeTimesADayTextField.isHidden = false
//            default:
//                break
//            }
//        } else {
//            let row = pillModel.dosage[pickerView.selectedRow(inComponent: 0)]
//            textField.text = row
//            userDefaults.set(row, forKey: "dosageRow")
//        }
//        self.endEditing(true)
//    }
}



