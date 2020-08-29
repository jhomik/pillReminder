//
//  CustomButton.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/5/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {
    //what exacly mean CusomButton? Maybe there's a better name for that
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
        // magic numbers
        backgroundColor = Constants.mainColor
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitleColor(.systemBackground, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
