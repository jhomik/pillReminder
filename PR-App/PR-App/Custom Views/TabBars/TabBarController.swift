//
//  TabBarController.swift
//  PR-App
//
//  Created by Jakub Homik on 19/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UserMedicationInfoNavigationController(), ReminderForMedicationNavigationController()]
        UITabBar.appearance().tintColor = UIColor.mainColor
        UINavigationBar.appearance().tintColor = UIColor.mainColor
    }
    
    private func UserMedicationInfoNavigationController() -> UINavigationController {
        let userMedicationInfoVC = UserMedicationInfoViewController()
        userMedicationInfoVC.tabBarItem = UITabBarItem(title: "Medicine", image: UIImage(systemName: "eyedropper.halffull"), tag: 0)
        
        
        return UINavigationController(rootViewController: userMedicationInfoVC)
    }
    
    private func ReminderForMedicationNavigationController() -> UINavigationController {
        let reminderForMedication = ReminderForMedicationViewController()
        reminderForMedication.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(systemName: "alarm.fill"), tag: 1)
        
        return UINavigationController(rootViewController: reminderForMedication)
    }
}
