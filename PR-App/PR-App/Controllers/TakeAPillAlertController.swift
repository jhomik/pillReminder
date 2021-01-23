//
//  TakeAPillAlertController.swift
//  PR-App
//
//  Created by Jakub Homik on 25/10/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class TakeAPillAlertController: UIViewController {
    
    private let takeAPillView = TakeAPillView()
    
    override func loadView() {
        self.view = takeAPillView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTakeAPillAlertController()
    }
    
    private func configureTakeAPillAlertController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
}
