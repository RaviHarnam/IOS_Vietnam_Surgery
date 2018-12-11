//
//  TabBarController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 01/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor(red: 38/255, green: 196/255, blue: 133, alpha: 1)
        setupTabbar()
    }
    
    func setupTabbar() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem.image = UIImage(named: "icon")
        homeViewController.tabBarItem.selectedImage = UIImage(named: "AppIcon-1")
        homeViewController.tabBarItem.title = "Home"
        
        let formViewController = UINavigationController(rootViewController: FormViewController())
        formViewController.tabBarItem.image = UIImage(named: "form")
        formViewController.tabBarItem.image = UIImage(named: "medical-history")
        formViewController.tabBarItem.title = "Choose Form"
        
        let formManagementViewController = UINavigationController(rootViewController: FormManagementViewController())
        formManagementViewController.tabBarItem.image = UIImage(named: "consent")
        formManagementViewController.tabBarItem.image = UIImage(named: "clinic-history")
        formManagementViewController.tabBarItem.title = "Form Management"
        
        viewControllers	= [homeViewController, formViewController, formManagementViewController]
    }
    
}
