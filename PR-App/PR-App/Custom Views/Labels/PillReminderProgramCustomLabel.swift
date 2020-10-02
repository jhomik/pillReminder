//
//  PillReminderProgramCustomLabel.swift
//  PR-App
//
//  Created by Jakub Homik on 28/09/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class PillReminderProgramCustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textAlignment = .left
    }
}
