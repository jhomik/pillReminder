//
//  TabBarController.swift
//  PR-App
//
//  Created by Jakub Homik on 19/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [UserMedicationInfoNavigationController(), ReminderForMedicationNavigationController()]
    }
    
    func UserMedicationInfoNavigationController() -> UINavigationController {
        let navBar = UserMedicationInfoVC()
        navBar.tabBarItem = UITabBarItem(title: "Medicine", image: UIImage(systemName: "eyedropper.halffull"), tag: 0)
        
        return UINavigationController(rootViewController: navBar)
    }
    
    func ReminderForMedicationNavigationController() -> UINavigationController {
        let navBar = ReminderForMedicationVC()
        navBar.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(systemName: "alarm.fill"), tag: 1)
        
        return UINavigationController(rootViewController: navBar)
    }
}
