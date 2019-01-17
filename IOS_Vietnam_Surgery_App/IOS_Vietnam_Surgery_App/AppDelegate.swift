//
//  AppDelegate.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 14/11/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public static var authenticationToken : String? {
        didSet {
            if authenticationToken == nil {
                userRole = nil
                LoggedInDelegateNotifier.notifyLoggedOut()
            }
        }
    }
    public static var userRole : String? {
        didSet {
            if userRole != nil {
                let isAdmin = userRole?.lowercased() == "admin"
                LoggedInDelegateNotifier.notifyLoggedIn(isAdmin)
            }
        }
    }
    
    public static var userName : String?
    public static var userTab : UITabBarController?
    public static var adminTab : UITabBarController?
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
//        let mainVC = TabBarController()
//        window?.rootViewController = mainVC
//        AppDelegate.userTab = UITabBarController()
//        var userVCArr = TabBarHelper.createUserTabBar()
//        
//        AppDelegate.userTab!.viewControllers = userVCArr.map{ UINavigationController.init(rootViewController: $0)}
//        
//        AppDelegate.adminTab = UITabBarController()
//        
//        var admintabbar = TabBarHelper.createAdminTabBar()
//        AppDelegate.adminTab?.viewControllers = admintabbar.map {UINavigationController.init(rootViewController:$0)}
        //
        
        MSAppCenter.start("523552e6-bfae-40e1-ac52-8c1b109b7204", withServices:[ MSAnalytics.self, MSCrashes.self ])
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


}

