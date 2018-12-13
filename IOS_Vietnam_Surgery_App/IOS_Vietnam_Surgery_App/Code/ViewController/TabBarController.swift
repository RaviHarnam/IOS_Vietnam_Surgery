//
//  TabBarController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor(red: 38/255, green: 196/255, blue: 133, alpha: 1)
        setupTabbar()
    }
    
    func setupTabbar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController, selectedImage:"icon" , unselectedImage: "AppIcon-1", title: "Home")
        
        
        let formViewController = createNavigationController(VController: FormViewController(), selectedImage:"medical-history", unselectedImage: "form", title: "Choose Form")
        
        
        let formManagementViewController = createNavigationController(VController: FormManagementViewController(), selectedImage:"clinic-history" , unselectedImage: "consent", title: "Form Management")
        
        let loginViewController = createNavigationController(VController: storyboard.instantiateViewController(withIdentifier:"LoginID") as! LoginViewController, selectedImage: "login", unselectedImage: "login", title: "Login")
        
        viewControllers = [homeViewController, formViewController, formManagementViewController, loginViewController]
        
        
        setupTabBarItems()
    }
    
    
    func setupTabBarItems() {
        
        guard let tabbaritems = tabBar.items else { return }
        
        for item in tabbaritems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}

extension UITabBarController {
    func createNavigationController(VController: UIViewController, selectedImage: String, unselectedImage: String, title: String) -> UINavigationController
    {
        let viewController = VController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: unselectedImage)
        navigationController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        navigationController.tabBarItem.title = title
        
        return navigationController
    }
}
