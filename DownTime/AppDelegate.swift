//
//  AppDelegate.swift
//  DownTime
//
//  Created by 江其 on 2018/4/25.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //后台任务
    var backgroundTask: UIBackgroundTaskIdentifier! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow()
        self.window?.rootViewController = BBBB()
        window?.makeKeyAndVisible()
//        self.window?.delete(self)
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        print("===从活动状态进入非活动状态")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("===程序进入后台时调用")
        
        let app = UIApplication.shared
        
        var bgTask: UIBackgroundTaskIdentifier? = nil
        
        bgTask = app.beginBackgroundTask(expirationHandler: {
            DispatchQueue.main.async {
                if bgTask != UIBackgroundTaskInvalid{
                    bgTask = UIBackgroundTaskInvalid
                }
            }
        })
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if bgTask != UIBackgroundTaskInvalid{
                    bgTask = UIBackgroundTaskInvalid
                }
            }
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("===程序进入前台，但是还没有处于活动状态时调用")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("===程序进入前台并处于活动状态时调用")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("===程序被杀死时调用")
    }


}

