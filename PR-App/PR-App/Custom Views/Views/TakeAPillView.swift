//
//  TakeAPillView.swift
//  PR-App
//
//  Created by Jakub Homik on 25/10/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class TakeAPillView: UIView {

    lazy private(set) var titleLabel = PillReminderMainCustomLabel(text: Constants.didYouTakePill + "\(viewModel.medications?.pillName ?? "") ?", alignment: .center, size: 24, weight: .bold, color: UIColor.textFieldUnderline)
    private let buttonTookAPill = PillReminderMainCustomButton(text: Constants.yes)
    private let buttonSnoozeAPill = PillReminderMainCustomButton(text: Constants.snoozeFor5Minutes)
    private let containerView = UIView()
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var viewModel: TakeAPillViewModel
    
    init(viewModel: TakeAPillViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureContainerView()
        configureTitleLabel()
        configureButtonTookAPill()
        configureButtonSnoozeAPill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContainerView() {
        self.addSubview(containerView)
        containerView.backgroundColor = UIColor.cellBackgroundColor
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor.systemBackground.cgColor
        containerView.layer.borderWidth = 2
        
        containerView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.equalTo(220)
            make.width.equalTo(280)
        }
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(40)
        }
    }
    
    private func configureButtonTookAPill() {
        containerView.addSubview(buttonTookAPill)
        buttonTookAPill.addTarget(self, action: #selector(tookAPillButtonTapped), for: .touchUpInside)
        
        buttonTookAPill.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
    
    @objc private func tookAPillButtonTapped() {
        viewModel.decreasePillValue {
            viewModel.takeAPillDelegate?.onButtonTapped()
        }
    }
    
    private func configureButtonSnoozeAPill() {
        containerView.addSubview(buttonSnoozeAPill)
        buttonSnoozeAPill.addTarget(self, action: #selector(snoozeAPillButtonTapped), for: .touchUpInside)
        
        buttonSnoozeAPill.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(buttonTookAPill.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    @objc private func snoozeAPillButtonTapped() {
        appDelegate?.snoozeNotification(for: 5, medicationID: viewModel.medications?.userIdentifier ?? "", completion: {
            viewModel.takeAPillDelegate?.onButtonTapped()
        })
    }
}
