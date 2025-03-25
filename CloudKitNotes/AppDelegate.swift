//
//  AppDelegate.swift
//  CloudKitNotes
//
//  Created by ec2-user on 24/03/2025.
//
import UIKit
import UserNotifications
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // Called when the app first launches
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestNotificationPermission() // Request notification permission
        return true
    }
    
    // Request push notifications permission
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                self.registerForPushNotifications()
            } else {
                print("User denied push notifications")
            }
        }
    }
    
    // Register for push notifications (device token registration)
    func registerForPushNotifications() {
        DispatchQueue.main.async {
            // Register for remote notifications
            UIApplication.shared.registerForRemoteNotifications()
            
            // Call createCloudKitSubscription after push notification permission is granted
            self.createCloudKitSubscription()
        }
    }

    // Handle device token registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        // Handle the device token here (send it to the server or store it)
        print("Device token: \(deviceToken)")
    }

    // Handle push notification errors
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error)")
    }


    // Handle push notifications when the app is in the foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Process the noticiation payload
        print("Received push notification in foreground: \(userInfo)")
        
        // Parse the notification data (you can access any data you sent with the notification)
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] as? String {
                print("Alert message: \(alert)")
            }
        }
        
        // Optionally update the app UI or fetch new data based on the notification
        // (You might want to refresh you UI or fetch data from CloudKit here)
        CloudKitHelper.shared.fetchNotes { _, _ in
            print("Fetched notes after saving.")
        }
    }
        
    
    // Handle push notifications when the app is in the background or terminated
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received push notification: \(userInfo)")
        
        // Process the notification data (similar to the foreground handler
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] as? String {
                print("Alert message: \(alert)")
            }
        }
        
        // Optionally, fetch new data or update UI based on the notification
        // If the app fetches new data form CloudKit, you can call completionHandler with .newData, .noData, or .failed
        CloudKitHelper.shared.fetchNotes { _, _ in
            print("Fetched notes after saving.")
        }
        
        // Once your background task is finished, call the completion handler
        completionHandler(.newData)
    }
    
    
    func createCloudKitSubscription() {
        let predicate = NSPredicate(value: true) // All records will trigger the subscription
        let subscription = CKQuerySubscription(recordType: "Note", predicate: predicate, options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "Your note has been updated!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        publicDatabase.save(subscription) { subscription, error in
            if let error = error {
                print("Error saving subscription: \(error.localizedDescription)")
            } else {
                print("Subscription created successfully")
            }
        }
        
    }

}
























