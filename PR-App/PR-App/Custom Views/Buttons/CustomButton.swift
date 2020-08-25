//
//  CustomButton.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/5/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {

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
        layer.cornerRadius = 10
        backgroundColor = Constants.mainColor
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitleColor(.systemBackground, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
