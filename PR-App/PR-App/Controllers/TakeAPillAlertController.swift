//
//  TakeAPillAlertController.swift
//  PR-App
//
//  Created by Jakub Homik on 25/10/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class TakeAPillAlertController: UIViewController {
    
    private let userDefaults = MedicationInfoDefaults()
    lazy private(set) var viewModel = TakeAPillViewModel(userDefaults: userDefaults)
    lazy private(set) var takeAPillView = TakeAPillView(viewModel: viewModel)
    
    override func loadView() {
        self.view = takeAPillView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTakeAPillAlertController()
        viewModel.takeAPillDelegate = self
    }
    
    private func configureTakeAPillAlertController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
}

extension TakeAPillAlertController: TakeAPillEventDelegate {
    func onButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
