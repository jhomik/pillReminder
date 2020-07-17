//
//  MainCoordinator.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {

    var navigationController: UINavigationController
    private(set) var childCoordinator = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginScreenVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func didLogin() {
        self.navigationController.showAlert(message: "Logged In") { [weak self] in
            self?.showUserMedicationInfo()
        }
    }
    
    private func showUserMedicationInfo() {
        let vc = UserMedicationInfoVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showUserMedicationDetail() {
        let child = UserMedicationDetailCoordinator(navigationController: navigationController)
        childCoordinator.append(child)
        print(childCoordinator)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
}
