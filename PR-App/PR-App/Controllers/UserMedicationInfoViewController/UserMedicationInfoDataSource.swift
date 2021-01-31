//
//  UserMedicationInfoDataSource.swift
//  PillReminder
//
//  Created by Jakub Homik on 13/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationInfoDataSource: NSObject, UICollectionViewDataSource {

    var viewModel: UserMedicationInfoViewModel
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    init(viewModel: UserMedicationInfoViewModel) {
        self.viewModel = viewModel
    }
    
    private func deleteItem(for item: CustomCell, collectionView: UICollectionView) {
        if let indexPath = collectionView.indexPath(for: item) {
            viewModel.deleteItemAt(indexPath)
            appDelegate?.deletePendingNotification(medicationID: item.customMedicationCell?.userIdentifier)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerViewId, for: indexPath)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.medications.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.customCellId, for: indexPath) as? CustomCell else { return UICollectionViewCell() }
        cell.deleteButton.isHidden = !viewModel.isActiveEditButton
        cell.deleteButtonEvent = { [weak self, unowned cell] in
            self?.deleteItem(for: cell, collectionView: collectionView)
        }
        
        if viewModel.medications.indices.contains(indexPath.item) == true {
            cell.customMedicationCell = viewModel.medications[indexPath.item]
            return cell
        } else {
            guard let staticAddCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.addMedicationCellId, for: indexPath) as? AddMedicationCell else { return UICollectionViewCell() }
            staticAddCell.configureAddMedicationCell()
            return staticAddCell
        }
    }
}
