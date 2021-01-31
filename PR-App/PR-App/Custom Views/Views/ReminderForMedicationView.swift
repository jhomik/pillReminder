//
//  ReminderForMedicationView.swift
//  PillReminder
//
//  Created by Jakub Homik on 21/01/2021.
//  Copyright © 2021 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

class ReminderForMedicationView: UIView {
    
    private let tableView = UITableView()
    
    private(set) var viewModel: ReminderViewModel
    lazy private(set) var remindersDataSource = ReminderForMedicationDataSource(viewModel: viewModel)
    
    init(viewModel: ReminderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureTableView()
        viewModel.reminderEvent = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        self.addSubview(tableView)
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.rowHeight = 80
        tableView.dataSource = remindersDataSource
        tableView.register(ReminderCell.self, forCellReuseIdentifier: Constants.reminderCellId)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
    }
}

extension ReminderForMedicationView: ReminderViewEventDelegate {
    func reloadReminders() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
