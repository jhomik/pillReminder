//
//  CustomCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomCell: UICollectionViewCell {
    
    static let reuseId = "CustomCell"
    
    var imageCell = UIImageView()
    var newMedsTitle = UILabel()
    var firebaseManager = FirebaseManager()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureSubviewsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureNewMedicationCell(with image: UIImage, title: String) {
        self.imageCell.image = image
        self.newMedsTitle.text = title
    }
    
    public func configureMedicationCell(with urlImageString: String, title: String) {
        firebaseManager.downloadImage(with: urlImageString, imageCell: imageCell)
        
        self.newMedsTitle.text = title
    }
    
    private func configureSubviewsInCell() {
        self.addSubview(imageCell)
        self.addSubview(newMedsTitle)
        newMedsTitle.translatesAutoresizingMaskIntoConstraints = false
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        newMedsTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newMedsTitle.textAlignment = .center
        newMedsTitle.numberOfLines = 0
        
        imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = 20
        imageCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: newMedsTitle.topAnchor),
            
            newMedsTitle.topAnchor.constraint(equalTo: imageCell.bottomAnchor),
            newMedsTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            newMedsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newMedsTitle.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureCell() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemFill.cgColor
        backgroundColor = .secondarySystemFill
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
