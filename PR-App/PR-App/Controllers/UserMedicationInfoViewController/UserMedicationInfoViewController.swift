//
//  UserMedicationInfoViewController.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseAuth

final class UserMedicationInfoViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var viewModel = UserMedicationInfoViewModel()
    private let containerView = UIView()
    
//    lazy private(set) var userMedicationInfoView = UserMedicationInfoView(viewModel: viewModel)
    lazy private(set) var userMedicationDataSource = UserMedicationInfoDataSource(viewModel: viewModel)
    lazy private(set) var userMedicationDelegate = UserMedicationInfoDelegate(viewModel: viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        viewModel.downloadMedicationInfo()
        viewModel.delegateMedicationInfo = self
        collectionView?.backgroundColor = UIColor.backgroundColor
    }
    
//    override func loadView() {
//        self.view = userMedicationInfoView
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.signOut, style: .plain, target: self, action: #selector(logoutSession))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.back, style: .plain, target: self, action: nil)
        
        viewModel.setUserName(completion: { (userName) in
            self.navigationItem.title = Constants.hello + userName + "!"
        })
    }
    
    @objc private func logoutSession() {
        showUserAlertWithOptions(title: nil, message: Alerts.userSignOUt, actionTitle: Constants.signOut) {
            self.signOutUser()
        }
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            self.tabBarController?.navigationController?.popViewController(animated: true)
        } catch let error {
            self.showUserAlert(message: Errors.failedToSignOut + ":\(error)", withTime: nil, completion: nil)
        }
    }
    
    private func changeBarButtonItem() {
        let barButtonItem: UIBarButtonItem.SystemItem = viewModel.isActiveEditButton ? .cancel : .edit
        let button = UIBarButtonItem(barButtonSystemItem: barButtonItem, target: self, action: #selector(deleteMedication))
        button.isEnabled = viewModel.medications.count > 0 || viewModel.isActiveEditButton
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func deleteMedication() {
        viewModel.toggleEditButton()
    }
    
    private func configureCollectionView() {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        let heightHeaderSize: CGFloat = 80
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: heightHeaderSize)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: Constants.customCellId)
        collectionView?.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerViewId)
        collectionView?.register(AddMedicationCell.self, forCellWithReuseIdentifier: Constants.addMedicationCellId)
        collectionView?.dataSource = userMedicationDataSource
        collectionView?.delegate = userMedicationDelegate
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView ?? UICollectionView())
    }
}

extension UserMedicationInfoViewController: UserMedicationInfoEventDelegate {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func pushNewMedicationSettingsController() {
        let newMedicationSettings = NewMedicationSettingsViewController()
        present(UINavigationController(rootViewController: newMedicationSettings), animated: true, completion: nil)
    }
    
    func pushUserMedicationDetailController(with medications: UserMedicationDetailModel) {
        let userMedicationDetail = UserMedicationDetailViewController()
        userMedicationDetail.medications = medications
        self.navigationController?.pushViewController(userMedicationDetail, animated: true)
    }
    
    func updateBarButtonItem() {
        changeBarButtonItem()
    }
}
