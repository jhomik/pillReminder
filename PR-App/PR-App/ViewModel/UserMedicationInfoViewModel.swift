//
//  UserMedicationInfoViewModel.swift
//  PR-App
//
//  Created by Jakub Homik on 28/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import Foundation

protocol UserMedicationInfoEventDelegate: AnyObject {
    func reloadCollectionView()
    func updateBarButtonItem()
    func pushUserMedicationDetailController(with medications: UserMedicationDetailModel)
    func pushNewMedicationSettingsController()
}

final class UserMedicationInfoViewModel {
    
    weak var delegateMedicationInfo: UserMedicationInfoEventDelegate?
    
    private let firebaseManager = FirebaseManager()
    private(set) var medications: [UserMedicationDetailModel] = [] {
        didSet {
            delegateMedicationInfo?.updateBarButtonItem()
            delegateMedicationInfo?.reloadCollectionView()
        }
    }
    
    private(set) var isActiveEditButton = false {
        didSet {
            delegateMedicationInfo?.updateBarButtonItem()
            delegateMedicationInfo?.reloadCollectionView()
        }
    }
    
    func deleteItemAt(_ indexPath: IndexPath) {
        let model = medications[indexPath.item]
        medications.remove(at: indexPath.item)
        firebaseManager.removeDataFromFirebase(model: model)
    }
    
    func appendItemWith(_ model: UserMedicationDetailModel) {
        medications.append(model)
    }
    
    func insertItemAt() -> IndexPath {
        let indexPath = IndexPath(item: medications.count - 1, section: 0)
        return indexPath
    }
    
    func itemSelectedAt(indexPath: IndexPath) {
        delegateMedicationInfo?.pushUserMedicationDetailController(with: medications[indexPath.item])
    }
    
    func pushNewMedicationSettingsViewController() {
        delegateMedicationInfo?.pushNewMedicationSettingsController()
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        if medications.indices.contains(indexPath.item) {
            itemSelectedAt(indexPath: indexPath)
        } else {
            pushNewMedicationSettingsViewController()
        }
    }
    
    func toggleEditButton() {
        isActiveEditButton.toggle()
    }

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
    
    func downloadMedicationInfo() {
        firebaseManager.downloadMedicationInfo { [weak self] (result) in
            guard let self = self else { return }
            self.medications = result
        }
    }
    
    func removeDataFromFirebase(model: UserMedicationDetailModel) {
        firebaseManager.removeDataFromFirebase(model: model)
    }
}
