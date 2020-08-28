//
//  MainVC.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseAuth

final class UserMedicationInfoVC: UIViewController {
    
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
        updateMedicationInfo()
        collectionView?.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(logoutSession))
        changeBarButtonItem()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        
        viewModel.setUserName(completion: { (userName) in
            self.navigationItem.title = "Hello, " + userName + "!"
        })
    }
    
    @objc private func logoutSession() {
        showUserAlertWithOptions(title: nil, message: PRAlerts.userSignOUt.rawValue, actionTitle: "Sign Out") {
            self.signOutUser()
        }
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            self.tabBarController?.navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to sign out", error)
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
    
    private func updateMedicationInfo() {
        viewModel.updateMedicationInfo { [weak self] (result) in
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
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 20)
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 80)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseId)
        collectionView?.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: CustomCollectionViewHeader.reuseID)
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
        cell.deleteButton.isHidden = !isActiveEditButton
        cell.editButtonTapped = { [weak self] in
            self?.deleteItem(for: cell)
        }
        
        if medications.indices.contains(indexPath.item) == true {
            cell.configureMedicationCell(with: medications[indexPath.item].cellImage, title: medications[indexPath.item].pillName)
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
            let userMedicationDetail = UserMedicationDetailVC()
            userMedicationDetail.medications = medications[indexPath.item]
            self.navigationController?.pushViewController(userMedicationDetail, animated: true)
        } else {
            let viewModel = NewMedicationViewModel()
            viewModel.addCellDelegate = self
            let newMedicationVC = NewMedicationSettingsVC(viewModel: viewModel)
            present(UINavigationController(rootViewController: newMedicationVC), animated: true, completion: nil)
        }
    }
}

extension UserMedicationInfoVC: NewMedicationCellDelegate {
    func addNewMedicationCell(_ model: UserMedicationDetailModel) {
        medications.append(model)
        let indexPath = IndexPath(item: medications.count - 1, section: 0)
        self.collectionView?.performBatchUpdates({
            collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
    }
}

