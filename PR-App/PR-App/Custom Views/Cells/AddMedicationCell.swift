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
    private let imageCell = UIImageView()
    private let newMedsTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureCell()
        configureImageCell()
        configureNewMedsTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }
    
    public func configureAddMedicationCell(with image: UIImage, title: String) {
        self.imageCell.image = image
        self.newMedsTitle.text = title
    }
    
    private func configureImageCell() {
        let heightAndWidthAnchorConstant: CGFloat = 50
        let horizontalAnchorConstant: CGFloat = 10
        
        imageCell.contentMode = .scaleAspectFit
        imageCell.tintColor = UIColor.mainColor
        
        self.addSubview(imageCell)
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCell.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageCell.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -horizontalAnchorConstant),
            imageCell.heightAnchor.constraint(equalToConstant: heightAndWidthAnchorConstant),
            imageCell.widthAnchor.constraint(equalToConstant: heightAndWidthAnchorConstant)
        ])
    }
    
    private func configureNewMedsTitle() {
        let newMedsTitleFontSize: CGFloat = 16
        let newMedsTitleNumberOfLinesInContent: Int = 0
        let heightConstantConstraint: CGFloat = 40
        let bottomAnchorConstant: CGFloat = 10
        
        newMedsTitle.font = UIFont.systemFont(ofSize: newMedsTitleFontSize, weight: .medium)
        newMedsTitle.textAlignment = .center
        newMedsTitle.numberOfLines = newMedsTitleNumberOfLinesInContent
        
        self.addSubview(newMedsTitle)
        newMedsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newMedsTitle.topAnchor.constraint(equalTo: imageCell.bottomAnchor),
            newMedsTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            newMedsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomAnchorConstant),
            newMedsTitle.heightAnchor.constraint(equalToConstant: heightConstantConstraint)
        ])
    }
    
    private func configureCell() {
        let cellCornerRadius: CGFloat = 20
        let cellBorderWidth: CGFloat = 1
        let shadowOffsetWidth: CGFloat = 0.0
        let shadowOffsetHeight: CGFloat = 2.0
        let cellShadowRadius: CGFloat = 10
        let cellShadowOpacity: Float = 0.5
        
        self.layer.cornerRadius = cellCornerRadius
        self.layer.borderWidth = cellBorderWidth
        self.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.backgroundColor = .secondarySystemFill
        self.layer.backgroundColor = UIColor.cellBackgroundColor.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        self.layer.shadowRadius = cellShadowRadius
        self.layer.shadowOpacity = cellShadowOpacity
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}

