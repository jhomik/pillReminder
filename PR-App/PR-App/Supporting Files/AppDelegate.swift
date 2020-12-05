//
//  AppDelegate.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    private(set) var badgeCount = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: options) { (success, _) in
            if !success {
                print("User has declined notifications")
            }
        }
        
        notificationCenter.getPendingNotificationRequests { (request) in
            print("Count: \(request.count)")
            for item in request {
                print(item.content)
                print("Identifier: \(item.identifier)")
            }
        }
        
        FirebaseApp.configure()
        return true
    }
    
    func scheduleNotification(pillOfTheDay: PillOfTheDay, scheduleNotoficationData: ScheduleNotoficationData) {
        
        let date = scheduleNotoficationData.time
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.body = Constants.tapNotification
        content.sound = .default
        content.badge = badgeCount
        
        switch pillOfTheDay {
        case .first:
            content.title = Constants.firstPill + "\(scheduleNotoficationData.pillName)"
            scheduleNotoficationData.textField.text = DateFormatter().string(from: scheduleNotoficationData.time)
        case .second:
            content.title = Constants.secondPill + "\(scheduleNotoficationData.pillName)"
            scheduleNotoficationData.textField.text = DateFormatter().string(from: scheduleNotoficationData.time)
        case .last:
            content.title = Constants.thirdPill + "\(scheduleNotoficationData.pillName)"
            scheduleNotoficationData.textField.text = DateFormatter().string(from: scheduleNotoficationData.time)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            print(triggerDate)
        }
    }
    
    func nextTriggerDate(label: UILabel) {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "EEEE, MM-dd-yyyy HH:mm"

        notificationCenter.getPendingNotificationRequests { (notifications) in
            for item in notifications {
                if let trigger = item.trigger as? UNCalendarNotificationTrigger,
                   let triggerDate = trigger.nextTriggerDate() {
                    let nextDate = dateFormmater.string(from: triggerDate)
                    DispatchQueue.main.async {
                        label.text = Constants.nextPill + "\(nextDate)"
                    }
                }
            }
        }
    }
    
    func deletePendingNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PR_App")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else { return }
        
        let takeAPillVC = TakeAPillAlertController()
        takeAPillVC.modalPresentationStyle = .overFullScreen
        takeAPillVC.modalTransitionStyle = .crossDissolve
        rootViewController.present(takeAPillVC, animated: true)
        
        completionHandler()
    }
}
