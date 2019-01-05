//
//  TabBarHelper.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 28/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class TabBarHelper : UITabBarController {
    
    static var VCArray : [UIViewController]!
    
//    public static func createAdminTabBar() -> UITabBarController {
//        let tabbar = UITabBarController()
////        tabbar.view.frame = CGRect(x: 0, y: 896 , width: 414, height: 40)
////
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let formTemplateViewController = tabbar.createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"icon" , unselectedImage: "AppIcon-1", title: "Home")
//
//
//        let formViewController = tabbar.createNavigationController(VController: FormViewController(), selectedImage:"medical-history", unselectedImage: "form", title: "Choose Form")
//
//
//        let formManagementViewController = tabbar.createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormManagementViewController"), selectedImage:"clinic-history" , unselectedImage: "consent", title: "Form Management")
//        
//        let loginViewController = tabbar.createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "login", unselectedImage: "login", title: "Login")
//
//        tabbar.viewControllers = [formTemplateViewController, formViewController, formManagementViewController, loginViewController]
//
////        tabbar.tabBar.items = setupTabBarItems(tabbar: tabbar)
//        if let tabbaritems = tabbar.tabBar.items {
//            for item in tabbaritems {
//                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
//            }
//        }
//        else
//        {
//            print("Failed")
//        }
//        tabbar.view.frame = CGRect(x: 0, y: 0 , width: 414, height: 100)
//        tabbar.tabBar.tintColor = UIColor.blue
//
//        return tabbar
//    }
    
    public static func createAdminTabBar() -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let firstVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"FormFillInViewController") as! FormFillInViewController, selectedImage: "form", title: "Form")
        let firstVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "UserTableViewController"), selectedImage: "usermanagement", title: "UserManagement")
        
        let secondVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormManagementViewController"), selectedImage: "consent", title: "FormManagement")
        
//        let secondVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "login", title: "Login")
        
        let thirdVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "logout", title: "Log out")
        
      
        

        
        let VCArray = [firstVc, secondVc, thirdVc]
        
        return VCArray
    }
//
    public static func createUserTabBar() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginID")
        
        let firstVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"FormTemplateViewController") as! FormTemplateViewController, selectedImage: "form", title: "Form")
        
//        firstVc.title = "First"
//        firstVc.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "icon"), tag: 0)
        
         let secondVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "login", title: "Login")
        
        let thirdVc = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "medical-history", title: "Login")
        
//        let secondVc = loginVC
//        secondVc.title = "Second"
//        secondVc.tabBarItem = UITabBarItem.init(title: "Login", image: UIImage(named: "login"), tag: 0)
        
        let VCArray = [firstVc, secondVc, thirdVc]
        
        return VCArray
    }
    
   private static func setupTabBarItems(tabbar: UITabBarController) -> [UITabBarItem]? {
    
        guard let tabbaritems = tabbar.tabBar.items else { return nil }
    
        for item in tabbaritems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        return tabbaritems
    }
    
}

//extension UITabBarController {
//    func createNavigationController(VController: UIViewController, selectedImage: String, unselectedImage: String, title: String) -> UINavigationController
//    {
//        let viewController = VController
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.tabBarItem.image = UIImage(named: unselectedImage)
//        navigationController.tabBarItem.selectedImage = UIImage(named: selectedImage)
//        navigationController.tabBarItem.title = title
//
//        return navigationController
//    }
//}

extension UITabBarController {
   static func createNavigationController(VController: UIViewController, selectedImage: String,title: String) -> UIViewController
    {
        let viewController = VController
        viewController.tabBarItem.image = UIImage(named: selectedImage)
        viewController.tabBarItem.title = title
        
        return viewController
    }
}
