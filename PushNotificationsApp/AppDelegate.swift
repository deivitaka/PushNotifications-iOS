//
//  AppDelegate.swift
//  PushNotificationsApp
//
//  Created by Deivi Taka on 6/28/16.
//  Copyright © 2016 Deivi Taka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.applicationIconBadgeNumber = 0; // Clear badge when app is launched
        
        // Check if launched from notification
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            window?.rootViewController?.present(ViewController(), animated: true, completion: nil)
            notificationReceived(notification: notification)
        } else {
            registerPushNotifications()
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func registerPushNotifications() {
        DispatchQueue.main.async { 
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared().registerUserNotificationSettings(settings)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = UnsafePointer<CChar>((deviceToken as NSData).bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        notificationReceived(notification: userInfo)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        notificationReceived(notification: userInfo)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0; // Clear badge when app is or resumed
    }
    
    func notificationReceived(notification: [NSObject:AnyObject]) {
        let viewController = window?.rootViewController
        let view = viewController as? ViewController
        view?.addNotification(
            title: getAlert(notification: notification).0,
            body: getAlert(notification: notification).1)
    }
    
    private func getAlert(notification: [NSObject:AnyObject]) -> (String, String) {
        let aps = notification["aps"] as? [String:AnyObject]
        let alert = aps?["alert"] as? [String:AnyObject]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        return (title ?? "-", body ?? "-")
    }
}

