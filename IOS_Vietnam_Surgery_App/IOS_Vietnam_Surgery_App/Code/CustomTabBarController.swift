//
//  CustomTabBarController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 03/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class CustomTabBarController : UITabBarController {
    
    //public let loggedInNotifier = LoggedInDelegateNotifier()
    private var vcontrollers : [UIViewController] = []
    
    public override func viewDidLoad() {
        LoggedInDelegateNotifier.delegate = self
        
        showUserActions()
        //setTitles()
    }
    
//    public var isLoggedIn : Bool = false {
//        didSet {
//            if isLoggedIn {
//                showUserActions()
//                setTitles()
//            }
//            else {
//                showAdminActions()
//                setTitles()
//            }
//        }
//    }
    
    
    
//    public override func viewWillAppear(_ animated: Bool) {
//
//        self.viewControllers?.removeAll()
//        //showUserActions()
//
//
//        if AppDelegate.authenticationToken != nil {
//        //   print("Adminactions")
//            showAdminActions()
//       }
//        else{
//            showUserActions()
//        }
//        setTitles()
//    }
    
    public  func setTitles() {
        if let items = self.tabBar.items {
            var i = 0
            for item in items {
                //let vc = viewControllers[i]
                item.title = NSLocalizedString(String(describing: type(of: self.vcontrollers[i])) + "TabTitle", comment: "")
                i = i + 1
            }
        }
    }
    
    public  func showUserActions() {
//        if let items = self.tabBar.items {
//            var i = 0
//            for item in items {
//                if item.title == "User Management" {
//                    self.viewControllers?.remove(at: i)
//                    //self.tabBar.items = items
//                }
//                i = i + 1
//            }
//        }
        self.viewControllers?.removeAll()
        self.vcontrollers.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let templateVC = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let formOverviewVC = storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController
        
        
        self.vcontrollers.append(templateVC)
        self.vcontrollers.append(loginVC)
        self.vcontrollers.append(formOverviewVC)

        //let userNav = UINavigationController(rootViewController: userVC)
        let loginNav = UINavigationController(rootViewController: loginVC)
        let templateNav = UINavigationController(rootViewController: templateVC)
        let formoverviewNav = UINavigationController(rootViewController: formOverviewVC)
        self.viewControllers?.append(templateNav)
        self.viewControllers?.append(loginNav)
        self.viewControllers?.append(formoverviewNav)
        //self.viewControllers?.append(userNav)
        setTitles()
    }
    
    public  func showAdminActions() {
        self.viewControllers?.removeAll()
        self.vcontrollers.removeAll()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let templateVC = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController")
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.vcontrollers.append(userVC)
        self.vcontrollers.append(templateVC)
        self.vcontrollers.append(loginVC)
        
        let userNav = UINavigationController(rootViewController: userVC)
        let loginNav = UINavigationController(rootViewController: loginVC)
        let templateNav = UINavigationController(rootViewController: templateVC)
        self.viewControllers?.append(userNav)
        self.viewControllers?.append(templateNav)
        self.viewControllers?.append(loginNav)
        
        setTitles()
    }
   
}

extension CustomTabBarController : LoggedInDelegate {
    public func loggedIn(_ isAdmin: Bool) {
        if isAdmin {
            self.showAdminActions()
        }
//        else {
//            self.showUserActions()
//        }
    }
    
    public func loggedOut() {
        self.showUserActions()
    }
}
