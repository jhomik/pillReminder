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
    let deleteButton = UIButton()
    private var firebaseManager = FirebaseManager()
    var editButtonTapped: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureSubviewsInCell()
        configureDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.deleteButton.layer.cornerRadius = self.deleteButton.bounds.width / 2
        deleteButton.layer.masksToBounds = true
    }
    
    public func configureNewMedicationCell(with image: UIImage, title: String) {
        self.imageCell.image = image
        self.newMedsTitle.text = title
    }
    
    public func configureMedicationCell(with urlImageString: String, title: String) {
        firebaseManager.downloadImage(with: urlImageString, imageCell: imageCell)
        self.newMedsTitle.text = title
    }
    
    func configureDeleteButton() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: imageConfiguration), for: .normal)
        deleteButton.tintColor = Constants.mainColor
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.backgroundColor = .systemBackground
        self.deleteButton.layer.cornerRadius = self.deleteButton.bounds.width / 2
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -10),
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -10),
        ])
    }
    
    @objc func deleteButtonTapped() {
        print("delete button tapped")
        editButtonTapped()
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
