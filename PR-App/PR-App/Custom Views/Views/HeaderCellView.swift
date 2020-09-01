//
//  HeaderCellView.swift
//  PR-App
//
//  Created by Jakub Homik on 23/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class HeaderCellView: UIView {
    
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
        let headerLabelFontSize: CGFloat = 16
        let leadingAnchorConstant: CGFloat = 16
        
        headerLabel.text = titleLabel
        headerLabel.backgroundColor = UIColor.backgroundColor
        headerLabel.font = UIFont.systemFont(ofSize: headerLabelFontSize, weight: .bold)
        
        self.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchorConstant),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
