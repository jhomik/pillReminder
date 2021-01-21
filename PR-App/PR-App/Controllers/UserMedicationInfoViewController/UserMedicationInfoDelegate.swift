//
//  UserMedicationInfoDelegate.swift
//  PillReminder
//
//  Created by Jakub Homik on 14/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationInfoDelegate: NSObject, UICollectionViewDelegate {
    
    var viewModel: UserMedicationInfoViewModel
    
    init(viewModel: UserMedicationInfoViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerViewId, for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
}
