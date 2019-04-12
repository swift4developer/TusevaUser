//
//  AppDelegate.swift
//  Tuseva
//
//  Created by Praveen Khare on 25/07/17.
//  Copyright © 2017 Praveen Khare. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import FBSDKCoreKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        let backgroundImage = UIImage(named: "nav_bg")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 15, 0, 15), resizingMode: UIImageResizingMode.stretch)
        
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let backArrowImage = UIImage(named: "backbtn")
        let renderedImage = backArrowImage?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = renderedImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = renderedImage
        
        
        // Push Notification
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        } else {
            // Fallback on earlier versions
        }
        registerForPushNotifications()
        
        
        
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
//        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
        
        
        // Use Firebase library to configure APIs
        //        FirebaseApp.configure()
        FIRApp.configure()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        return  FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication!, annotation: annotation)
        
    }
    
    // MARK: NOTIFICATION
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                
//                // 1
//                let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
//                                                      title: "View",
//                                                      options: [.foreground])
//                
//                // 2
//                let newsCategory = UNNotificationCategory(identifier: newsCategoryIdentifier,
//                                                          actions: [viewAction],
//                                                          intentIdentifiers: [],
//                                                          options: [])
//                // 3
//                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                
                
                self.getNotificationSettings()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        let aps = userInfo["aps"] as! [String: AnyObject]
        // 1
//        if aps["content-available"] as? Int == 1 {
//            let podcastStore = PodcastStore.sharedStore
//            // Refresh Podcast
//            // 2
//            podcastStore.refreshItems { didLoadNewItems in
//                // 3
//                completionHandler(didLoadNewItems ? .newData : .noData)
//            }
//        } else  {
//            // News
//            // 4
//            _ = NewsItem.makeNewsItem(aps)
//            completionHandler(.newData)
//        }
    }
    
    
//     func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("DEVICE TOKEN = \(deviceToken)")
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print(error)
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        print(userInfo)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        // 1
//        let userInfo = response.notification.request.content.userInfo
//        let aps = userInfo["aps"] as! [String: AnyObject]
//        
//        // 2
//        if let newsItem = NewsItem.makeNewsItem(aps) {
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//            
//            // 3
//            if response.actionIdentifier == viewActionIdentifier,
//                let url = URL(string: newsItem.link) {
//                let safari = SFSafariViewController(url: url)
//                window?.rootViewController?.present(safari, animated: true, completion: nil)
//            }
//        }
//        
//        // 4
//        completionHandler()
//    }
//}
