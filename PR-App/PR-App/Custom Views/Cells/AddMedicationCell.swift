//
//  AddMedicationCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class AddMedicationCell: UICollectionViewCell {
    static let reuseId = "AddMedicationCell"
    
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
    
    public func configureAddMedicationCell(with image: UIImage, title: String) {
        self.imageCell.image = image
        self.newMedsTitle.text = title
    }
    
    private func configureSubviewsInCell() {
        self.addSubview(imageCell)
        self.addSubview(newMedsTitle)
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        newMedsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        imageCell.contentMode = .scaleAspectFit
        imageCell.tintColor = Constants.mainColor
        
        newMedsTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newMedsTitle.textAlignment = .center
        newMedsTitle.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            imageCell.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageCell.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            imageCell.heightAnchor.constraint(equalToConstant: 50),
            imageCell.widthAnchor.constraint(equalToConstant: 50),
            
            newMedsTitle.topAnchor.constraint(equalTo: imageCell.bottomAnchor),
            newMedsTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            newMedsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
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

