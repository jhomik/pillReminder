//
//  MainVC.swift
//  PR-App
//
//  Created by Jakub Homik on 12/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class UserMedicationInfoVC: UIViewController {
    
    var collectionView: UICollectionView?
    var logoView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureViewController()
        collectionView?.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureViewController() {
        self.navigationItem.title = "Logged in UserName"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(setupNotification))
    }
    
    @objc private func setupNotification() {
        print("notifcation tapped")
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
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(CustomCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerView")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView ?? UICollectionView())
    }
    
    private func configreTitleView() {
        
    }
}

extension UserMedicationInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.imageCell.image = Constants.cellImage
        cell.newMedsTitle.text = Constants.cellText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomCellHeader.reuseID, for: indexPath)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = UserMedicationDetailVC()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

}
