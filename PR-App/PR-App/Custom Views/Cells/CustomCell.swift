//
//  CustomCell.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomCell: UICollectionViewCell {
    
    static let reuseId = "cell"
    
    var imageCell = UIImageView()
    var newMedsTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureButtonImage()
        configureMedsTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, title: String) {
        self.imageCell.image = image
        self.newMedsTitle.text = title
    }
    
    private func configureButtonImage() {
        addSubview(imageCell)
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            imageCell.widthAnchor.constraint(equalToConstant: 50),
            imageCell.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureMedsTitle() {
        newMedsTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        newMedsTitle.textAlignment = .center
        newMedsTitle.numberOfLines = 0

        newMedsTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newMedsTitle)
        
        NSLayoutConstraint.activate([
            newMedsTitle.topAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: 20),
            newMedsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newMedsTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
        layer.masksToBounds = false
    }
}
