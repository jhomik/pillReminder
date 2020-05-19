//
//  CustomCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    var addButtonImage = UIButton(type: .system)
    var addNewMedsTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureButtonImage()
        configureMedsTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonImage() {
        
        let addButton = UIImage(systemName: "plus.circle.fill")
        addButtonImage.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addButtonImage.setBackgroundImage(addButton, for: .normal)
        
        addSubview(addButtonImage)
        addButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButtonImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButtonImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            addButtonImage.widthAnchor.constraint(equalToConstant: 50),
            addButtonImage.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func buttonTapped() {
        print("push a controller with userDetailInfoVC")
    }
    
    private func configureMedsTitle() {
        
        addNewMedsTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        addNewMedsTitle.textAlignment = .center
        addNewMedsTitle.numberOfLines = 0
        
        addNewMedsTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addNewMedsTitle)
        
        NSLayoutConstraint.activate([
            
            addNewMedsTitle.topAnchor.constraint(equalTo: addButtonImage.bottomAnchor, constant: 20),
            addNewMedsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addNewMedsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addNewMedsTitle.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureCell() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondarySystemFill.cgColor
        backgroundColor = .secondarySystemFill
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
}
