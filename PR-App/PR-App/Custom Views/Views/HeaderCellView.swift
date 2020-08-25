//
//  HeaderCellView.swift
//  PR-App
//
//  Created by Jakub Homik on 23/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class HeaderCellView: UIView {
    
    private let headerLabel = UILabel()
    private var titleLabel: String
    
    init(frame: CGRect, titleLabel: String) {
        self.titleLabel = titleLabel
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        headerLabel.text = titleLabel
        headerLabel.backgroundColor = Constants.backgroundColor
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        self.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
