//
//  TakeAPillView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/10/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class TakeAPillView: UIView {

    private let titleLabel = PillReminderMainCustomLabel(text: "Did you take a pill?", alignment: .center, size: 24, weight: .bold, color: .black)
    private let buttonTookAPill = PillReminderMainCustomButton(text: "Yes")
    private let buttonSnoozeAPill = PillReminderMainCustomButton(text: "Snooze for 5 minutes")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
        configureTitleLabel()
        configureButtonTookAPill()
        configureButtonSnoozeAPill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        self.backgroundColor = UIColor.backgroundColor
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.systemBackground.cgColor
        self.layer.borderWidth = 2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureButtonTookAPill() {
        self.addSubview(buttonTookAPill)
        buttonTookAPill.addTarget(self, action: #selector(tookAPillButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonTookAPill.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            buttonTookAPill.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonTookAPill.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonTookAPill.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func tookAPillButtonTapped() {
        print("test")
    }
    
    private func configureButtonSnoozeAPill() {
        self.addSubview(buttonSnoozeAPill)
        buttonSnoozeAPill.addTarget(self, action: #selector(snoozeAPillButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonSnoozeAPill.topAnchor.constraint(equalTo: buttonTookAPill.bottomAnchor, constant: 10),
            buttonSnoozeAPill.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonSnoozeAPill.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonSnoozeAPill.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func snoozeAPillButtonTapped() {
        print("test")
    }
}
