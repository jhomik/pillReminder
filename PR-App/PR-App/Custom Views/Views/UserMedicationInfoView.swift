//
//  UserMedicationInfoView.swift
//  PillReminder
//
//  Created by Jakub Homik on 14/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

class UserMedicationInfoView: UIView {
    
    private let containerView = UIView()
    private let spinner = UIActivityIndicatorView()

    private(set) var collectionView: UICollectionView?
    private(set) var viewModel: UserMedicationInfoViewModel

    lazy private(set) var userMedicationDataSource = UserMedicationInfoDataSource(viewModel: viewModel)
    lazy private(set) var userMedicationDelegate = UserMedicationInfoDelegate(viewModel: viewModel)

    init(viewModel: UserMedicationInfoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureCollectionView()
        viewModel.downloadMedicationInfo()
        viewModel.updateCollectionView = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: How to call this method inside NewMedicationSettingsViewController?

    func addMedCell(_ model: UserMedicationDetailModel) {
        viewModel.appendItemWith(model)
        self.collectionView?.performBatchUpdates({
            collectionView?.insertItems(at: [viewModel.insertItemAt()])
        })
    }

    private func configureCollectionView() {
        let width = UIScreen.main.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        let heightHeaderSize: CGFloat = 80

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        flowLayout.headerReferenceSize = CGSize(width: self.frame.width, height: heightHeaderSize)

        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: Constants.customCellId)
        collectionView?.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerViewId)
        collectionView?.register(AddMedicationCell.self, forCellWithReuseIdentifier: Constants.addMedicationCellId)
        collectionView?.dataSource = userMedicationDataSource
        collectionView?.delegate = userMedicationDelegate
        collectionView?.backgroundColor = UIColor.backgroundColor
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalTo(self)
        })
    }
}

extension UserMedicationInfoView: UpdateCollectionViewDelegate {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            print("reloadMyCollectionView")
        }
    }
}
