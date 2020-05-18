//
//  CheckBoxButton.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/13/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(isSelected: Bool) {
        self.isSelected.toggle()
        if isSelected {
            setTitle("X", for: .normal)
        } else {
            setTitle("", for: .normal)
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        layer.cornerRadius                          = 5
        layer.borderColor                           = UIColor.systemGray.cgColor
        layer.borderWidth                           = 1
        setTitleColor(.black, for: .normal)
        
    }

}
