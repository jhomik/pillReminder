//
//  MainVC.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationInfoVC: UIViewController {
    
    private var collectionView: UICollectionView?
    private let firebaseManager = FirebaseManager()
    private var medications: [UserMedicationDetailModel] = []
    private let containerView = UIView()
    private var isActiveEditButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        updateMedicationInfo()
        collectionView?.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(setupNotification))
        changeBarButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        
        firebaseManager.observeUserName() { result in
            switch result {
            case .success(let userName):
                self.navigationItem.title = "Hello, " + userName + "!"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func setupNotification() {
        print("notifcation tapped")
    }
    
    private func changeBarButtonItem() {
        let barButtonItem: UIBarButtonItem.SystemItem = isActiveEditButton ? .cancel : .edit
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonItem, target: self, action: #selector(deleteMedication))
    }
    
    @objc private func deleteMedication() {
        isActiveEditButton.toggle()
        changeBarButtonItem()
    }
    
    private func updateMedicationInfo() {
        firebaseManager.downloadMedicationInfo { [weak self] (result) in
            self?.medications = result
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    
    private func deleteItem(for item: CustomCell) {
        collectionView?.performBatchUpdates({
            if let indexPath = collectionView?.indexPath(for: item) {
                medications.remove(at: indexPath.item)
                let indexPath = IndexPath(item: indexPath.item, section: 0)
                collectionView?.deleteItems(at: [indexPath])
                collectionView?.reloadData()
            }
        }, completion: nil)
    }
    
    private func configureCollectionView() {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 80)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseId)
        collectionView?.register(CustomCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: CustomCellHeader.reuseID)
        collectionView?.register(AddMedicationCell.self, forCellWithReuseIdentifier: AddMedicationCell.reuseId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView ?? UICollectionView())
    }
}

extension UserMedicationInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medications.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseId, for: indexPath) as! CustomCell
        cell.imageCell.image = UIImage()
        cell.deleteButton.isHidden = isActiveEditButton
        cell.editButtonTapped = { [weak self] in
            self?.deleteItem(for: cell)
        }
        
        if medications.indices.contains(indexPath.item) == true {
            cell.configureMedicationCell(with: medications[indexPath.item].cellImage, title: medications[indexPath.item].pillName)
            return cell
        } else {
            let addMedCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMedicationCell.reuseId, for: indexPath) as! AddMedicationCell
            addMedCell.configureNewMedicationCell(with: Constants.cellImage, title: Constants.addMedication)
            return addMedCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomCellHeader.reuseID, for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if medications.indices.contains(indexPath.item) == true {
            let userMedicationDetail = UserMedicationDetailVC()
            userMedicationDetail.medications = medications[indexPath.item]
            self.navigationController?.pushViewController(userMedicationDetail, animated: true)
        } else {
            let newMedicationVC = NewMedicationSettingsVC()
            newMedicationVC.addDelegate = self
            present(UINavigationController(rootViewController: newMedicationVC), animated: true, completion: nil)
        }
    }
}

extension UserMedicationInfoVC: NewMedicationCellDelegate {
    func addNewMedicationCell(pillName: String, capacity: String, dose: String, cellImageUrl: String) {
        self.collectionView?.performBatchUpdates({
            let newCell = UserMedicationDetailModel(pillName: pillName, capacity: capacity, dose: dose, cellImage: cellImageUrl)
            medications.append(newCell)
            let indexPath = IndexPath(item: medications.count - 1, section: 0)
            collectionView?.insertItems(at: [indexPath])
            collectionView?.reloadData()
        }, completion: nil)
    }
}
