//
//  UserMedicationInfoCoordinator.swift
//  PR-App
//
//  Created by Jakub Homik on 29/06/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit

class UserMedicationInfoCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = UserMedicationInfoVC()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishUserMedication() {
        parentCoordinator?.childDidFinish(self)
    }
    
    //    public func start() {
    //        let favoriteCoordinator = self.getFavoriteTab()
    //        let mainNavigationCoordinator = self.getMainTab()
    //
    //        self.children = [mainNavigationCoordinator, favoriteCoordinator]
    //        self.tabBarController.setViewControllers([mainNavigationCoordinator.navigationController, favoriteCoordinator.navigationController], animated: false)
    //        self.window.rootViewController = self.tabBarController
    //        self.window.makeKeyAndVisible()
    //    }
    //
    //    private func getMainTab() -> NavigationCoordinator {
    //        let mainNavigationCoordinator = NavigationCoordinator()
    //        let mainTableController = MainTableViewController()
    //        mainTableController.title = "Feed"
    //        mainTableController.articleLoader = NetworkManager.shared
    //        mainTableController.presentDetails = { [weak mainNavigationCoordinator] viewModel in
    //            mainNavigationCoordinator?.presentArticleDetails(viewModel)
    //        }
    //        mainNavigationCoordinator.start(viewController: mainTableController)
    //        mainTableController.coordinator = mainNavigationCoordinator
    //
    //        let mainNavigationController = mainNavigationCoordinator.navigationController
    //        mainNavigationController.tabBarItem = UITabBarItem(
    //            title: mainTableController.title,
    //            image: UIImage(systemName: "folder"),
    //            selectedImage: UIImage(systemName: "folder.fill"))
    //
    //        return mainNavigationCoordinator
    //    }
    //
    //    private func getFavoriteTab() -> NavigationCoordinator {
    //        let favoriteCoordinator = NavigationCoordinator()
    //
    //        let favoriteVC = FavoritesVC()
    //        favoriteVC.coordinator = favoriteCoordinator
    //
    //        favoriteCoordinator.start(viewController: favoriteVC)
    //        favoriteVC.title = "Favorites"
    //        let favoriteNavigationController = favoriteCoordinator.navigationController
    //        favoriteNavigationController.tabBarItem = UITabBarItem(
    //            title: favoriteVC.title,
    //            image: UIImage(systemName: "star"),
    //            selectedImage: UIImage(systemName: "star.fill"))
    //        return favoriteCoordinator
    //    }
    
}
//final class TabBarController: UITabBarController {
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    viewControllers = [UserMedicationInfoNavigationController(), ReminderForMedicationNavigationController()]
//}
//
//private func UserMedicationInfoNavigationController() -> UINavigationController {
//    let userMedicationInfoVC = UserMedicationInfoVC()
//    userMedicationInfoVC.tabBarItem = UITabBarItem(title: "Medicine", image: UIImage(systemName: "eyedropper.halffull"), tag: 0)
//
//    return UINavigationController(rootViewController: userMedicationInfoVC)
//}
//
//private func ReminderForMedicationNavigationController() -> UINavigationController {
//    let reminderForMedication = ReminderForMedicationVC()
//    reminderForMedication.tabBarItem = UITabBarItem(title: "Reminder", image: UIImage(systemName: "alarm.fill"), tag: 1)
//
//    return UINavigationController(rootViewController: reminderForMedication)
//}
