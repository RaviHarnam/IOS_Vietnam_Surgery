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
    
    private var vcontrollers : [UIViewController] = []
    
    public override func viewDidLoad() {
        LoggedInDelegateNotifier.delegate = self
        
        showUserActions()
    }
    
    public  func setTitles() {
        if let items = self.tabBar.items {
            var i = 0
            for item in items {
                item.title = NSLocalizedString(String(describing: type(of: self.vcontrollers[i])) + "TabTitle", comment: "")
                i = i + 1
            }
        }
    }
    
    public func appendViewControllers (viewControllers: [UIViewController]) {
        
        for vc in viewControllers {
            self.vcontrollers.append(vc)
            
        }
        
    }
    
    public func vcRemoveAll() {
        
        self.viewControllers?.removeAll()
        self.vcontrollers.removeAll()
    }
    
    public  func showUserActions() {
        
        vcRemoveAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let templateVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"form")
        let loginVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController, selectedImage: "login")
        
        let formOverviewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        
        let tabBarViewControllers = [templateVC, formOverviewVC, loginVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        
        appendNavigationController(viewControllers: tabBarViewControllers)
        
        setTitles()
    }
    
    public func appendNavigationController(viewControllers: [UIViewController]) {
        for viewController in viewControllers {
            
            let navController = UINavigationController(rootViewController: viewController)
            
            self.viewControllers?.append(navController)
        }
    }
    
    public func loggedInAsUserActions() {
        
        vcRemoveAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let templateVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"form")
        let logoutVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController, selectedImage: "logout")
        let formOverviewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        
        let tabBarViewControllers = [templateVC, formOverviewVC, logoutVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        appendNavigationController(viewControllers: tabBarViewControllers)
        
        setTitles()
    }
    
    public func AddViewControllers(viewController: UIViewController) {
        self.vcontrollers.append(viewController)
    }
    
    public func AddNavcontrollers(navController: UINavigationController) {
        self.viewControllers?.append(navController)
    }
    
    public  func showAdminActions() {
        
        vcRemoveAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "UserManagementViewController") as! UserManagementViewController, selectedImage: "usermanagement")
        let formOverViewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        let formMangementVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormManagementViewController") as! FormManagementViewController, selectedImage: "formmanagement")
        let logoutVC = UITabBarController.createViewController(VController:  storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController, selectedImage: "logout")
        
        let tabBarViewControllers =  [userVC, formMangementVC, formOverViewVC, logoutVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        appendNavigationController(viewControllers: tabBarViewControllers)
        setTitles()
    }
}

extension CustomTabBarController : LoggedInDelegate {
    public func loggedIn(_ isAdmin: Bool) {
        if isAdmin {
            self.showAdminActions()
        }
        else {
            self.loggedInAsUserActions()
        }
    }
    
    public func loggedOut() {
        self.showUserActions()
    }
}

extension UITabBarController {
    static func createViewController(VController: UIViewController, selectedImage: String) -> UIViewController {
        let viewController = VController
        viewController.tabBarItem.image = UIImage(named: selectedImage)
        
        return viewController
    }
    
    static func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let VController = rootViewController
        let navigationController = UINavigationController(rootViewController: VController)
        
        return navigationController
    }
    
}
