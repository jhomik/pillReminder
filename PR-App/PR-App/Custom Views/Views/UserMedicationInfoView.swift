//
//  UserMedicationInfoView.swift
//  PillReminder
//
//  Created by Jakub Homik on 14/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit

class UserMedicationInfoView: UIView {

//    private var collectionView: UICollectionView?
//    private(set) var viewModel: UserMedicationInfoViewModel
//    private let containerView = UIView()
//
//    lazy var userMedicationDataSource = UserMedicationInfoDataSource(viewModel: viewModel)
//    lazy var userMedicationDelegate = UserMedicationInfoDelegate(viewModel: viewModel)
//
//    init(viewModel: UserMedicationInfoViewModel) {
//        self.viewModel = viewModel
//        super.init(frame: .zero)
//        viewModel.updateMedications = self
//        configureCollectionView()
//        viewModel.downloadMedicationInfo()
//        collectionView?.backgroundColor = UIColor.backgroundColor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func addMedCell(_ model: UserMedicationDetailModel) {
//        viewModel.appendItemWith(model)
//        self.collectionView?.performBatchUpdates({
//            collectionView?.insertItems(at: [viewModel.insertItemAt()])
//        })
//    }
//
//    private func configureCollectionView() {
//        let width = self.bounds.width
//        let padding: CGFloat = 20
//        let minimumItemSpacing: CGFloat = 10
//        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
//        let itemWidth = availableWidth / 2
//        let heightHeaderSize: CGFloat = 80
//
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
//        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
//        flowLayout.headerReferenceSize = CGSize(width: self.frame.width, height: heightHeaderSize)
//
//        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
//        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: Constants.customCellId)
//        collectionView?.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerViewId)
//        collectionView?.register(AddMedicationCell.self, forCellWithReuseIdentifier: Constants.addMedicationCellId)
//        collectionView?.dataSource = userMedicationDataSource
//        collectionView?.delegate = userMedicationDelegate
//        collectionView?.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(collectionView ?? UICollectionView())
//    }
//}
//
//extension UserMedicationInfoView: UpdateMedicationsDelegate {
//    func reloadCollectionView() {
//        DispatchQueue.main.async {
//            self.collectionView?.reloadData()
//        }
//    }
}
