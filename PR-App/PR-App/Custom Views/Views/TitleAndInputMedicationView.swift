//
//  TitleAndInputMedicationView.swift
//  PR-App
//
//  Created by Jakub Homik on 17/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class TitleAndInputMedicationView: UIView {
    
    private var title: NSAttributedString = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.systemGray2])
    
    private var input: NSAttributedString = NSAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.mainColor])
    
    private lazy var titleLabel: PillReminderMainCustomLabel = {
        return PillReminderMainCustomLabel(text: self.title, alignment: .left)
    }()
    private lazy var inputLabel: PillReminderMainCustomLabel = {
        return PillReminderMainCustomLabel(text: self.input, alignment: .left)
    }()
    
    convenience init(title: NSAttributedString, input: NSAttributedString) {
        self.init(frame: .zero)
        self.title = title
        self.input = input
        configureTitleLabel()
        configureInputLabel()
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
        }
    }
    
    private func configureInputLabel() {
        let bottomAnchorConstant: CGFloat = 12
        
        addSubview(inputLabel)
        
        inputLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-bottomAnchorConstant)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    func updateInputValue(_ text: NSAttributedString) {
        self.inputLabel.updateText(text)
    }
}
