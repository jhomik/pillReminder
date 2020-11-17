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
    private var medications: [UserMedicationDetailModel] = [] {
        didSet {
            changeBarButtonItem()
        }
    }
    
    private var isActiveEditButton = false {
        didSet {
            changeBarButtonItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        downloadMedicationInfo()
        collectionView?.backgroundColor = UIColor.backgroundColor
    }
    
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
        } catch {
            self.showUserAlert(message: Errors.failedToSignOut + ":\(error)", withTime: nil, completion: nil)
        }
    }
    
    private func changeBarButtonItem() {
        let barButtonItem: UIBarButtonItem.SystemItem = isActiveEditButton ? .cancel : .edit
        let button = UIBarButtonItem(barButtonSystemItem: barButtonItem, target: self, action: #selector(deleteMedication))
        button.isEnabled = medications.count > 0 || isActiveEditButton
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func deleteMedication() {
        isActiveEditButton.toggle()
        self.collectionView?.reloadData()
    }
    
    private func downloadMedicationInfo() {
        viewModel.downloadMedicationInfo { [weak self] (result) in
            guard let self = self else { return }
            self.medications = result
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func deleteItem(for item: CustomCell) {
        if let indexPath = collectionView?.indexPath(for: item) {
            let model = medications[indexPath.item]
            medications.remove(at: indexPath.item)
            collectionView?.performBatchUpdates({
                collectionView?.deleteItems(at: [indexPath])
            }, completion: { _ in
                self.viewModel.removeDataFromFirebase(model: model)
            })
        }
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
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseId)
        collectionView?.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionViewHeader.reuseID)
        collectionView?.register(AddMedicationCell.self, forCellWithReuseIdentifier: AddMedicationCell.reuseId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView ?? UICollectionView())
    }
}

extension UserMedicationInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medications.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseId, for: indexPath) as! CustomCell
        cell.imageCell.image = UIImage()
        cell.placeholderImage.image = UIImage()
        cell.deleteButton.isHidden = !isActiveEditButton
        cell.deleteButtonEvent = { [weak self, unowned cell] in
            self?.deleteItem(for: cell)
        }
        
        if medications.indices.contains(indexPath.item) == true {
            guard let urlImage = medications[indexPath.item].cellImage else { return cell }
            let title = medications[indexPath.item].pillName
            
            cell.configureMedicationCell(with: urlImage, title: title)
            return cell
        } else {
            let addMedCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMedicationCell.reuseId, for: indexPath) as! AddMedicationCell
            addMedCell.configureAddMedicationCell(with: Images.cellImage ?? UIImage(), title: Constants.addMedication)
            return addMedCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomCollectionViewHeader.reuseID, for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if medications.indices.contains(indexPath.item) {
            let userMedicationDetail = UserMedicationDetailViewController()
            userMedicationDetail.medications = medications[indexPath.item]
            
            self.navigationController?.pushViewController(userMedicationDetail, animated: true)
        } else {
            let viewModel = NewMedicationViewModel()
            viewModel.addCellDelegate = self
            let newMedicationVC = UINavigationController(rootViewController: NewMedicationSettingsViewController(viewModel: viewModel))
            present(newMedicationVC, animated: true, completion: nil)
        }
    }
}

extension UserMedicationInfoViewController: NewMedicationCellDelegate {
    func addNewMedicationCell(_ model: UserMedicationDetailModel) {
        medications.append(model)
        let indexPath = IndexPath(item: medications.count - 1, section: 0)
        self.collectionView?.performBatchUpdates({
            collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
    }
}
