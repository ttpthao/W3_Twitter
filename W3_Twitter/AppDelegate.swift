//
//  AppDelegate.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/3/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.userDidLogout), name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
        if User.currentUser != nil {
            // Go to the logged in screen
            print("Current user is \(User.currentUser?.name)")
            let vc = storyboard.instantiateViewController(withIdentifier: "homeViewController")
            let nc = UINavigationController(rootViewController: vc)
            window?.rootViewController = nc
        }
        
//        if User.currentUser != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVc = storyboard.instantiateViewController(withIdentifier: "homeViewController")
//            self.window?.rootViewController = homeVc
//        }
//        
//        let notificationName = Notification.Name("UserDidLogout")
//        
//        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main) { (Notification) in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVc = storyboard.instantiateInitialViewController()
//            self.window?.rootViewController = loginVc
//        }

        return true
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance?.handleOpenUrl(url: url as NSURL?)
        
        return true
    }
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController()
        window?.rootViewController = vc
    }
}

