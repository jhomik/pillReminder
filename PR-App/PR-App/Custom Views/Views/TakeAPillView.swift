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
    }
    
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(40)
        }
    }
    
    private func configureButtonTookAPill() {
        self.addSubview(buttonTookAPill)
        buttonTookAPill.addTarget(self, action: #selector(tookAPillButtonTapped), for: .touchUpInside)
        
        buttonTookAPill.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
    
    @objc private func tookAPillButtonTapped() {
        print("test")
    }
    
    private func configureButtonSnoozeAPill() {
        self.addSubview(buttonSnoozeAPill)
        buttonSnoozeAPill.addTarget(self, action: #selector(snoozeAPillButtonTapped), for: .touchUpInside)
        
        buttonSnoozeAPill.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(buttonTookAPill.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    @objc private func snoozeAPillButtonTapped() {
        print("test")
    }
}
