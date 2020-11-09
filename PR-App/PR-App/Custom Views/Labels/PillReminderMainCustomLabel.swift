//
//  PillReminderMainCustomLabel.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class PillReminderMainCustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, alignment: NSTextAlignment, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        self.init(frame: .zero)
        self.textAlignment = alignment
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = color
    }
    
    convenience init(text: NSAttributedString, alignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.attributedText = text
        self.textAlignment = alignment
    }
    
    func updateText(_ text: NSAttributedString) {
        self.attributedText = text
    }
}
