//
//  AppDelegate.swift
//  PR-App
//
//  Created by Jakub Homik on 05/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseCore
import UserNotifications

struct ScheduleNotoficationData {
    var textField: UITextField
    let pillName: String
    let time: Date
}

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
    
    func scheduleNotification(pillOfTheDay: PillOfTheDay, scheduleNotoficationData: ScheduleNotoficationData, medicationModel: UserMedicationDetailModel?) {
        
        let date = scheduleNotoficationData.time
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.body = Constants.tapNotification
        content.sound = .default
        content.badge = badgeCount
        content.userInfo["medicationID"] = medicationModel?.userIdentifier ?? ""
        content.userInfo["medicationModel"] = try? JSONEncoder().encode(medicationModel)
        
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
            print(request.identifier)
        }
    }
    
    func updateNotofication(pillOfTheDay: PillOfTheDay, schedule: ScheduleNotoficationData, medicationModel: UserMedicationDetailModel?) {
        let date = schedule.time
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.body = Constants.tapNotification
        content.sound = .default
        content.badge = badgeCount
        content.userInfo["medicationID"] = medicationModel?.userIdentifier ?? ""
        content.userInfo["medicationModel"] = try? JSONEncoder().encode(medicationModel)
        
        switch pillOfTheDay {
        case .first:
            content.title = Constants.firstPill + "\(schedule.pillName)"
            schedule.textField.text = DateFormatter().string(from: schedule.time)
            content.categoryIdentifier = pillOfTheDay.rawValue + UUID().uuidString
        case .second:
            content.title = Constants.secondPill + "\(schedule.pillName)"
            schedule.textField.text = DateFormatter().string(from: schedule.time)
            content.categoryIdentifier = pillOfTheDay.rawValue + UUID().uuidString
        case .last:
            content.title = Constants.thirdPill + "\(schedule.pillName)"
            schedule.textField.text = DateFormatter().string(from: schedule.time)
            content.categoryIdentifier = pillOfTheDay.rawValue + UUID().uuidString
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString + "\(pillOfTheDay.rawValue)", content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            print(triggerDate)
            print(request.identifier)
        }
    }
    
    func snoozeNotification(for minutes: Int, medicationID: String, completion: () -> Void) {
        notificationCenter.getPendingNotificationRequests { (requests) in
            if let request = requests.last, let medID = request.content.userInfo["medicationID"] as? String, medID == medicationID {
                let time = Date()
                let content = request.content
                var triggerDate = Calendar.current.dateComponents([.hour, .minute], from: time)
                triggerDate.minute = (triggerDate.minute ?? 0) + minutes
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        print("Reschduling failed", error.localizedDescription)
                    }
                }
            }
        }
        completion()
    }
    
    func nextTriggerDate(label: UILabel, for medicationId: String?) {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "EEEE, MM-dd-yyyy HH:mm"
        
        notificationCenter.getPendingNotificationRequests { (requests) in
            var nextDate: [String] = []
            if let request = requests.last, let medID = request.content.userInfo["medicationID"] as? String, medID == medicationId {
                let trigger = request.trigger as? UNCalendarNotificationTrigger
                if let triggerDate = trigger?.nextTriggerDate() {
                    let dates = dateFormmater.string(from: triggerDate)
                    nextDate.append(dates)
                }
                DispatchQueue.main.async {
                    label.text = Constants.nextPill + "\(nextDate.min() ?? "")"
                }
            }
            print("My pending requests: \(requests)")
        }
    }
    
    func deletePendingNotification(medicationID: String?) {
        notificationCenter.getPendingNotificationRequests { (request) in
            for item in request {
                let userInfo = item.content.userInfo
                if let mediID = userInfo["medicationID"] as? String, mediID == medicationID {
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [item.identifier])
                }
            }
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
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else { return }
        let userInfoDecode = response.notification.request.content.userInfo["medicationModel"]
        
        guard let userInfo = userInfoDecode as? Data, let model = try? JSONDecoder().decode(UserMedicationDetailModel.self, from: userInfo) else { return }
        
        let takeAPillVC = TakeAPillAlertController()
        takeAPillVC.modalPresentationStyle = .overFullScreen
        takeAPillVC.modalTransitionStyle = .crossDissolve
        takeAPillVC.viewModel.medications = model
        rootViewController.present(takeAPillVC, animated: true)
        
        completionHandler()
    }
}
