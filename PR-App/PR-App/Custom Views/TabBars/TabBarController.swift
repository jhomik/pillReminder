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
        viewControllers = [userMedicationInfoNavigationController(), reminderForMedicationNavigationController()]
        UITabBar.appearance().tintColor = UIColor.mainColor
        UINavigationBar.appearance().tintColor = UIColor.mainColor
    }
    
    private func userMedicationInfoNavigationController() -> UINavigationController {
        let userMedicationInfoVC = UserMedicationInfoViewController()
        userMedicationInfoVC.tabBarItem = UITabBarItem(title: Constants.medicine, image: UIImage(systemName: "eyedropper.halffull"), tag: 0)
        
        return UINavigationController(rootViewController: userMedicationInfoVC)
    }
    
    private func reminderForMedicationNavigationController() -> UINavigationController {
        let reminderForMedication = ReminderForMedicationViewController()
        reminderForMedication.tabBarItem = UITabBarItem(title: Constants.reminder, image: UIImage(systemName: "alarm.fill"), tag: 1)
        
        return UINavigationController(rootViewController: reminderForMedication)
    }
}
