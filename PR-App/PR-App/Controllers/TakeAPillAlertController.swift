//
//  TakeAPillAlertController.swift
//  PR-App
//
//  Created by Jakub Homik on 25/10/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

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
        
        takeAPillView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.height.equalTo(220)
            make.width.equalTo(280)
        }
    }
}
