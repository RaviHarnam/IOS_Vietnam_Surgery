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
                item.title = NSLocalizedString(String(describing: type(of: self.vcontrollers[i])) + "TabTitle", comment: "")
                i = i + 1
            }
        }
    }
    
    public  func showUserActions() {
        self.viewControllers?.removeAll()
        self.vcontrollers.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        
        
        let templateVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"form")
            
            //storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let formOverviewVC = storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController
        
        
        self.vcontrollers.append(templateVC)
        self.vcontrollers.append(loginVC)
        self.vcontrollers.append(formOverviewVC)

        //let userNav = UINavigationController(rootViewController: userVC)
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.tabBarItem.image = UIImage(named: "login")

        let templateNav = UINavigationController(rootViewController: templateVC)
        let formoverviewNav = UINavigationController(rootViewController: formOverviewVC)
        formoverviewNav.tabBarItem.image = UIImage(named:"medical-history")
        self.viewControllers?.append(templateNav)
        self.viewControllers?.append(loginNav)
        self.viewControllers?.append(formoverviewNav)
        //self.viewControllers?.append(userNav)
        setTitles()
    }
    
    
    public func AddViewControllers(viewController: UIViewController) {
        
        self.vcontrollers.append(viewController)
    
    }
    
    public func AddNavcontrollers(navController: UINavigationController) {
        self.viewControllers?.append(navController)
    }
    public  func showAdminActions() {
        self.viewControllers?.removeAll()
        self.vcontrollers.removeAll()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        let templateVC = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController")
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")


        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let formManagementVC = storyboard.instantiateViewController(withIdentifier: "FormManagementViewController")
        

        self.vcontrollers.append(userVC)
        self.vcontrollers.append(templateVC)
        self.vcontrollers.append(loginVC)
        self.vcontrollers.append(formManagementVC)
        
        let userNav = UINavigationController(rootViewController: userVC)
        let loginNav = UINavigationController(rootViewController: loginVC)
        let templateNav = UINavigationController(rootViewController: templateVC)

        userNav.tabBarItem.image = UIImage(named:"usermanagement")

        let formManagementNav = UINavigationController(rootViewController: formManagementVC)
        
        self.viewControllers?.append(userNav)
        self.viewControllers?.append(templateNav)
        self.viewControllers?.append(loginNav)
        self.viewControllers?.append(formManagementNav)
        
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

extension UITabBarController {
    static func createViewController(VController: UIViewController, selectedImage: String) -> UIViewController
    {
        let viewController = VController
        viewController.tabBarItem.image = UIImage(named: selectedImage)
        
        return viewController
    }
    
    static func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
        	let VController = rootViewController
            let navigationController = UINavigationController(rootViewController: VController)
        
            //image moet hier eigenlijk toegevoegd worden
        return navigationController
    }
    
}
