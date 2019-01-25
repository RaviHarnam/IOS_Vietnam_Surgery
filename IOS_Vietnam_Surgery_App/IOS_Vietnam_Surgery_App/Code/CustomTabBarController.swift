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
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        
        
        let templateVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"form")
            
            //storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
       // let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let loginVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController, selectedImage: "login")
        
//        let formOverviewVC = storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController
        
        let formOverviewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        var tabBarViewControllers = [templateVC, formOverviewVC, loginVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        
        appendNavigationController(viewControllers: tabBarViewControllers)
//        self.vcontrollers.append(templateVC)
//        self.vcontrollers.append(formOverviewVC)
//        self.vcontrollers.append(loginVC)

        //let userNav = UINavigationController(rootViewController: userVC)
//        let loginNav = UINavigationController(rootViewController: loginVC)
//        loginNav.tabBarItem.image = UIImage(named: "login")
//        let templateNav = UINavigationController(rootViewController: templateVC)
//        let formoverviewNav = UINavigationController(rootViewController: formOverviewVC)
//        formoverviewNav.tabBarItem.image = UIImage(named:"medical-history")
//        self.viewControllers?.append(templateNav)
//
//        self.viewControllers?.append(formoverviewNav)
//        self.viewControllers?.append(loginNav)
        //self.viewControllers?.append(userNav)
        setTitles()
    }
    
    public func appendNavigationController(viewControllers: [UIViewController]) {
        for viewController in viewControllers {
            
            var navController = UINavigationController(rootViewController: viewController)
            
            self.viewControllers?.append(navController)
        }
    }
    
    public func loggedInAsUserActions() {
        
        vcRemoveAll()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        
        
        let templateVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"form")
        
        //storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        
        let logoutVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController, selectedImage: "logout")
        
        let formOverviewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        //let logoutVC = storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
        
      //  let formOverviewVC = storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController
        var tabBarViewControllers = [templateVC, formOverviewVC, logoutVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        appendNavigationController(viewControllers: tabBarViewControllers)
        
//        self.vcontrollers.append(templateVC)
//        self.vcontrollers.append(formOverviewVC)
//        self.vcontrollers.append(logoutVC)
//
//        //let userNav = UINavigationController(rootViewController: userVC)
//        let logoutNav = UINavigationController(rootViewController: logoutVC)
//        logoutNav.tabBarItem.image = UIImage(named: "logout")
//
//        let templateNav = UINavigationController(rootViewController: templateVC)
//        let formoverviewNav = UINavigationController(rootViewController: formOverviewVC)
//        formoverviewNav.tabBarItem.image = UIImage(named:"medical-history")
//        self.viewControllers?.append(templateNav)
//
//        self.viewControllers?.append(formoverviewNav)
//        self.viewControllers?.append(logoutNav)
//        //self.viewControllers?.append(userNav)
        setTitles()
    }
    
    public func AddViewControllers(viewController: UIViewController) {
        self.vcontrollers.append(viewController)
    }
    
    public func AddNavcontrollers(navController: UINavigationController) {
        self.viewControllers?.append(navController)
    }
    
    public  func showAdminActions() {
//        self.viewControllers?.removeAll()
//        self.vcontrollers.removeAll()
        vcRemoveAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let userVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
      //  let templateVC = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController")
//        let userVC = storyboard.instantiateViewController(withIdentifier: "UserManagementViewController") as! UserManagementViewController
//        let formOverViewVC = storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController
//
//        let logoutVC = storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
//        let formManagementVC = storyboard.instantiateViewController(withIdentifier: "FormManagementViewController")
        
        let userVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "UserManagementViewController") as! UserManagementViewController, selectedImage: "usermanagement")
        let formOverViewVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormOverviewViewController") as! FormOverviewViewController, selectedImage: "medical-history")
        let formMangementVC = UITabBarController.createViewController(VController: storyboard.instantiateViewController(withIdentifier: "FormManagementViewController") as! FormManagementViewController, selectedImage: "formmanagement")
        let logoutVC = UITabBarController.createViewController(VController:  storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController, selectedImage: "logout")

        var tabBarViewControllers =  [userVC, formMangementVC, formOverViewVC, logoutVC]
        
        appendViewControllers(viewControllers: tabBarViewControllers)
        appendNavigationController(viewControllers: tabBarViewControllers)
        
//        self.vcontrollers.append(userVC)
//       // self.vcontrollers.append(templateVC)
//        self.vcontrollers.append(formManagementVC)
//        self.vcontrollers.append(formOverViewVC)
//        self.vcontrollers.append(logoutVC)
//
//        let userNav = UINavigationController(rootViewController: userVC)
//       // let loginNav = UINavigationController(rootViewController: loginVC)
//       // let templateNav = UINavigationController(rootViewController: templateVC)
//        let formoverviewNav = UINavigationController(rootViewController: formOverViewVC)
//        let logOutNav = UINavigationController(rootViewController: logoutVC)
//
//
//        userNav.tabBarItem.image = UIImage(named:"usermanagement")
//        formOverViewVC.tabBarItem.image = UIImage(named: "medical-history")
//        formManagementVC.tabBarItem.image = UIImage(named: "formmanagement")
//        logoutVC.tabBarItem.image = UIImage(named:"logout")
//        let formManagementNav = UINavigationController(rootViewController: formManagementVC)
//
//        self.viewControllers?.append(userNav)
//        //self.viewControllers?.append(templateNav)
//        //self.viewControllers?.append(loginNav)
//        self.viewControllers?.append(formManagementNav)
//        self.viewControllers?.append(formoverviewNav)
//        self.viewControllers?.append(logOutNav)
//
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
        
            //image moet hier eigenlijk toegevoegd worden
        return navigationController
    }
    
}
