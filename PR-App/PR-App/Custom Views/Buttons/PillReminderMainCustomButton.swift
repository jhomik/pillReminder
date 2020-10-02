//
//  PillReminderMainCustomButton.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/5/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class PillReminderMainCustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        configure()
        setTitle(text, for: .normal)
    }
    
    private func configure() {
        let buttonCornerRadius: CGFloat = 10
        let buttonTitleFontsize: CGFloat = 18
        
        self.layer.cornerRadius = buttonCornerRadius
        self.backgroundColor = UIColor.mainColor
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonTitleFontsize)
        self.setTitleColor(.white, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
