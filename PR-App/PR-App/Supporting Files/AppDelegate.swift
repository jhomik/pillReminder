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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: options) { (success, error) in
            if !success {
                print("User has declined notifications")
            }
        }
        FirebaseApp.configure()
        return true
    }
    
    func scheduleNotification(pillOfTheDay: pillOfTheDay, textField: UITextField, identifier: String, pillName: String, time: Date) {
        
        let date = time
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        
        switch pillOfTheDay {
        case .first:
            content.body = Constants.firstPill + "\(pillName)"
            textField.text = DateFormatter().string(from: time)
        case .second:
            content.body = Constants.secondPill + "\(pillName)"
            textField.text = DateFormatter().string(from: time)
        case .last:
            content.body = Constants.thirdPill + "\(pillName)"
            textField.text = DateFormatter().string(from: time)
        }
        
        content.title = Constants.tapNotification
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            print(triggerDate)
        }
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
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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

