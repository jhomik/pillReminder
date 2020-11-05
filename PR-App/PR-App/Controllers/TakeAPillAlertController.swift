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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTakeAPillAlertController()
        configureTakeAPillView()
    }
    
    private func configureTakeAPillAlertController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    private func configureTakeAPillView() {
        view.addSubview(takeAPillView)
        
        NSLayoutConstraint.activate([
            takeAPillView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            takeAPillView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            takeAPillView.heightAnchor.constraint(equalToConstant: 220),
            takeAPillView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
}
