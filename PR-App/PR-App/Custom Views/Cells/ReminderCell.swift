//
//  ReminderCell.swift
//  PillReminder
//
//  Created by Jakub Homik on 28/11/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

class ReminderCell: UITableViewCell {

    private var imageCell = PillReminderImageView(frame: .zero)
    private var labelText = UILabel()
    private let detailLabelText = UILabel()
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var reminderModel: UserMedicationDetailModel? {
        didSet {
            updateCell()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureImageCell()
        configureLabelText()
        configureDetailLabelText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCell() {
        guard let imageUrl = reminderModel?.cellImage else { return }
        imageCell.downloadImage(with: imageUrl)
        labelText.text = reminderModel?.pillName
        appDelegate?.nextTriggerDate(label: detailLabelText, for: reminderModel?.userIdentifier)
    }
    
    private func configureCell() {
        self.backgroundColor = UIColor.backgroundColor
    }
    
    private func configureImageCell() {
        let padding: CGFloat = 12
        let heightAndWidth: CGFloat = 70
        self.addSubview(imageCell)
        
        imageCell.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(padding)
            make.height.width.equalTo(heightAndWidth)
        }
    }
    
    private func configureLabelText() {
        let padding: CGFloat = 12
        let height: CGFloat = 24
        self.addSubview(labelText)
        self.labelText.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        labelText.snp.makeConstraints { (make) in
            make.top.equalTo(padding)
            make.leading.equalTo(imageCell.snp.trailing).offset(padding)
            make.trailing.equalTo(self)
            make.height.equalTo(height)
        }
    }
    
    private func configureDetailLabelText() {
        let padding: CGFloat = 12
        let height: CGFloat = 40
        self.addSubview(detailLabelText)
        self.detailLabelText.font = UIFont.italicSystemFont(ofSize: 14)
        self.detailLabelText.numberOfLines = 2
        
        detailLabelText.snp.makeConstraints { (make) in
            make.top.equalTo(labelText.snp.bottom)
            make.leading.equalTo(imageCell.snp.trailing).offset(padding)
            make.trailing.equalTo(self)
            make.height.equalTo(height)
        }
    }
}
