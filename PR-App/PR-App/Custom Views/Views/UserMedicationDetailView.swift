//
//  UserMedicationDetailView.swift
//  PR-App
//
//  Created by Jakub Homik on 01/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailView: UIView {
    
    var pillImageView = UIImageView()
    private let placeholderImage = UIImageView()
    var firebaseManager = FirebaseManager()
    private let medicationStackView = UIStackView()
    var medicationToChange: UserMedicationDetailModel? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var pillNameView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.pillName,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var packageCapacityView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.capacity,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var pillDoseView = TitleAndInputMedicationView(
        title: NSAttributedString(string: Constants.dose,
                                  attributes: self.titleAttributes),
        input: NSAttributedString(string: "",
                                  attributes: self.inputAttributes))
    
    private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.systemGray2]
    }()
    
    private lazy var inputAttributes: [NSAttributedString.Key: Any] = {
        return [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.mainColor]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePillImageView()
        configurePlaceholderImageView()
        configureMedicationStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        guard let medication = medicationToChange else { return }
        updatePillNameValue(medication.pillName)
        updatePackageCapacityValue(medication.capacity)
        updatePillDoseValue(medication.dose)
        downloadImage(medication: medication)
    
    }
    
    private func downloadImage(medication: UserMedicationDetailModel) {
        if let cellImage = medication.cellImage, !cellImage.isEmpty {
            firebaseManager.downloadImage(with: cellImage, imageCell: pillImageView)
        } else {
            placeholderImage.image = Images.placeholderImage
        }
    }
    
    func updatePillNameValue(_ value: String) {
        self.pillNameView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    func updatePackageCapacityValue(_ value: String) {
        self.packageCapacityView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    func updatePillDoseValue(_ value: String) {
        self.pillDoseView.updateInputValue(NSAttributedString(string: value, attributes: self.inputAttributes))
    }
    
    private func configurePillImageView() {
        let pillImageCornerRadius: CGFloat = 16
        let widthAnchorMultiplier: CGFloat = 0.5
        
        pillImageView.backgroundColor = .systemGray5
        pillImageView.contentMode = .scaleAspectFill
        pillImageView.layer.masksToBounds = true
        pillImageView.layer.cornerRadius = pillImageCornerRadius
        
        self.addSubview(pillImageView)
        
        pillImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(self)
            make.width.equalTo(self).multipliedBy(widthAnchorMultiplier)
        }
    }
    
    private func configurePlaceholderImageView() {
        let imageCellCornerRadius: CGFloat = 20
        
        placeholderImage.clipsToBounds = true
        placeholderImage.layer.cornerRadius = imageCellCornerRadius
        placeholderImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        placeholderImage.contentMode = .scaleAspectFill
        placeholderImage.alpha = 0.3
        
        pillImageView.addSubview(placeholderImage)
        
        placeholderImage.snp.makeConstraints { (make) in
            make.top.leading.equalTo(30)
            make.trailing.bottom.equalTo(-30)
        }
    }
    
    private func configureMedicationStackView() {
        let leadingAnchorConstant: CGFloat = 30
        
        medicationStackView.axis = .vertical
        medicationStackView.distribution = .equalSpacing
        self.addSubview(medicationStackView)
        medicationStackView.addArrangedSubview(pillNameView)
        medicationStackView.addArrangedSubview(packageCapacityView)
        medicationStackView.addArrangedSubview(pillDoseView)
        
        medicationStackView.snp.makeConstraints { (make) in
            make.top.height.trailing.equalTo(self)
            make.leading.equalTo(pillImageView.snp.trailing).offset(leadingAnchorConstant)
        }
    }
}
