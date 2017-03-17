//
//  AppDelegate.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        PlantRepository.initialize()
        PlantBatchRepository.initialize()
        EventRepository.initialize()
        pendingActivities()
        return true
    }
    
    func pendingActivities() {
        if PlantRepository.findAll().count == 0 {
            return
        }
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if !granted {
                    
                }
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15,
                                                            repeats: false)
            // Schedule the notification.
            for  plant in PlantRepository.findAll() {
                if  plant.plantBatchList.isEmpty {
                    continue
                }
                let dayCount = plant.pendingSowDays()!
                if (dayCount < 0) {
                    continue
                }
                
                let content = UNMutableNotificationContent()
                content.title = String.localizedStringWithFormat(
                    NSLocalizedString("Sow plant", comment: ""),
                    plant.name)
                content.body = String.localizedStringWithFormat(
                    NSLocalizedString("days_overdue", comment: ""),
                    dayCount)
                content.sound = UNNotificationSound.default()
                let request = UNNotificationRequest(
                    identifier: plant.name,
                    content: content,
                    trigger: trigger)
                center.add(request)
            }
        }else {
            // Fallback on earlier versions
        }
        
    }
    
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

