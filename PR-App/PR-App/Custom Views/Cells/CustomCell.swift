//
//  CustomCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

final class CustomCell: UICollectionViewCell {
    
    static let reuseId = "CustomCell"
    var imageCell = UIImageView()
    var placeholderImage = UIImageView()
    var newMedsTitle = UILabel()
    var deleteButton = UIButton()
    private let firebaseManager = FirebaseManager()
    var deleteButtonEvent: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureImageCell()
        configurePlaceholderImageCell()
        configureNewMedsTitle()
        configureDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.deleteButton.layer.cornerRadius = self.deleteButton.bounds.width / 2
        deleteButton.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.cellBackgroundColor.cgColor
    }
    
    public func configureMedicationCell(with urlImageString: String, title: String) {
        if urlImageString.isEmpty {
            placeholderImage.image = Images.placeholderImage
        } else {
            firebaseManager.downloadImage(with: urlImageString, imageCell: imageCell)
        }
        newMedsTitle.text = title
    }
    
    func configureDeleteButton() {
        let deleteButtonSize: CGFloat = 25
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: deleteButtonSize, weight: .regular)
        let topAnchorConstant: CGFloat = 10
        let leadingAnchorConstant: CGFloat = 10
        
        deleteButton.setImage(UIImage(systemName: Images.cellDeleteButton, withConfiguration: imageConfiguration), for: .normal)
        deleteButton.tintColor = UIColor.mainColor
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.backgroundColor = UIColor.backgroundColor
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2
        
        self.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(-topAnchorConstant)
            make.leading.equalTo(-leadingAnchorConstant)
        }
    }
    
    @objc func deleteButtonTapped() {
        deleteButtonEvent()
    }

    private func configureImageCell() {
        let imageCellCornerRadius: CGFloat = 20
        
        imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = imageCellCornerRadius
        imageCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageCell.contentMode = .scaleAspectFill

        self.addSubview(imageCell)
        
        imageCell.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
        }
    }
    
    private func configurePlaceholderImageCell() {
        let imageCellCornerRadius: CGFloat = 20
        
        placeholderImage.clipsToBounds = true
        placeholderImage.layer.cornerRadius = imageCellCornerRadius
        placeholderImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        placeholderImage.contentMode = .scaleAspectFill
        placeholderImage.alpha = 0.3
        
        self.addSubview(placeholderImage)
        
        placeholderImage.snp.makeConstraints { (make) in
            make.top.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-50)
        }
    }
    
    private func configureNewMedsTitle() {
        let newMedsTitleFontSize: CGFloat = 16
        let newMedsTitleNumberOfLinesInContent: Int = 0
        let heightConstantConstraint: CGFloat = 40
        
        newMedsTitle.font = UIFont.systemFont(ofSize: newMedsTitleFontSize, weight: .medium)
        newMedsTitle.textAlignment = .center
        newMedsTitle.numberOfLines = newMedsTitleNumberOfLinesInContent
        
        self.addSubview(newMedsTitle)
        
        newMedsTitle.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(contentView)
            make.top.equalTo(imageCell.snp.bottom)
            make.height.equalTo(heightConstantConstraint)
        }
    }
    
    private func configureCell() {
        let cellCornerRadius: CGFloat = 20
        let cellBorderWidth: CGFloat = 2
        
        self.layer.cornerRadius = cellCornerRadius
        self.layer.borderWidth = cellBorderWidth
        self.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.backgroundColor = .secondarySystemFill
    }
}
