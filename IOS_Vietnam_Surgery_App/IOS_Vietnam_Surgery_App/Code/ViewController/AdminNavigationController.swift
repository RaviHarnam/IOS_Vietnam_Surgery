//
//  AdminNavigationController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 17/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

class AdminNavigationController : UINavigationController{
    let tabBarCnt = UITabBarController()

    override func viewDidLoad () {
        super.viewDidLoad()
        //createTabBarController()
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        navigateToUsersInterface()
//    }
    func loadAllUsers() {
        
    }
    
    func createTabBarController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let usersVC = storyboard.instantiateViewController(withIdentifier: "UserTableViewController")
        
        
        tabBarCnt.tabBar.tintColor = UIColor.green
        
//        let firstVc = UIViewController()
//        firstVc.title = "First"
//        firstVc.tabBarItem = UITabBarItem.init(title: "Choose Form", image: UIImage(named: "medical-history"), tag: 0)
//        let secondVc = usersVC
//        secondVc.title = "Second"
//        secondVc.tabBarItem = UITabBarItem.init(title: "User Management", image: UIImage(named: "usermanagement"), tag: 0)
        
        let controllerArray = TabBarHelper.createAdminTabBar()
        tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
        self.view.viewWithTag(2)
        self.view.addSubview(tabBarCnt.view)
    }
    
    
    private func navigateToUsersInterface () {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let adminNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "UserTableViewController") as? UserTableViewController else { return }
        
        present(adminNavigationVC, animated: true, completion: nil)
    }
}
