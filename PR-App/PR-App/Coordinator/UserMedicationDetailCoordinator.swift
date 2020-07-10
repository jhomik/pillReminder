//
//  UserMedicationDetailCoordinator.swift
//  PR-App
//
//  Created by Jakub Homik on 03/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class UserMedicationDetailCoordinator: Coordinator {
    
    private(set) var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = UserMedicationDetailVC()
        let pillViewModel = LoginScreenViewModel()
        vc.coordinator = self
        vc.viewModel = pillViewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
 
