//
//  AddMedicationCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/08/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

final class AddMedicationCell: UICollectionViewCell {
    
    static let reuseId = "AddMedicationCell"
    private let imageCell = UIImageView()
    private let newMedsTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
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
        
        imageCell.snp.makeConstraints { (make) in
            make.height.width.equalTo(heightAndWidthAnchorConstant)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-horizontalAnchorConstant)
        }
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
        
        newMedsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(imageCell.snp.bottom)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-bottomAnchorConstant)
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
        self.layer.backgroundColor = UIColor.cellBackgroundColor.cgColor
    }
}
