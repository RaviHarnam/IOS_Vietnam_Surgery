////
////  AdminTabBarControllerViewController.swift
////  IOS_Vietnam_Surgery_App
////
////  Created by Ravi on 25/12/2018.
////  Copyright © 2018 Matermind. All rights reserved.
////
//
//import UIKit
//
//class AdminTabBarControllerViewController: TabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabBar.barTintColor = UIColor(red: 38/255, green: 196/255, blue: 133, alpha: 1)
//        setupTabbar()
//    }
//    
//    override func setupTabbar() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let formTemplateViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"icon" , unselectedImage: "AppIcon-1", title: "Home")
//        
//        
//        let formViewController = createNavigationController(VController: FormViewController(), selectedImage:"medical-history", unselectedImage: "form", title: "Choose Form")
//        
//        
//        let formManagementViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormManagementViewController"), selectedImage:"clinic-history" , unselectedImage: "consent", title: "Form Management")
//        
//        let userManagementViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "UserTableViewController"), selectedImage: "usermanagement", unselectedImage: "usermanagement", title: "User manager")
//        
//        let loginViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "login", unselectedImage: "login", title: "Logout")
//        
//        viewControllers = [formTemplateViewController, formViewController, formManagementViewController, loginViewController]
//        
//        
//        setupTabBarItems()
//    }
//    
//    
//    override func setupTabBarItems() {
//        
//        guard let tabbaritems = tabBar.items else { return }
//        
//        for item in tabbaritems {
//            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
//        }
//    }
//}
//
