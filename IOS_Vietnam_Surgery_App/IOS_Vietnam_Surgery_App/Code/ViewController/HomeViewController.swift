//
//  HomeViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
        let tabBarCnt = UITabBarController()
        var viewTabar: UIView  = UIView()
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.blue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        //createTabBarController()
         //   if(AppDelegate.adminTab!.view.isHidden) {
//                AppDelegate.adminTab!.view.isHidden = false
//                print("Admintab tonen")
//            }
//            else if AppDelegate.userTab!.view.isHidden {
//                AppDelegate.userTab!.view.isHidden = false
//                print("Usertab tonen")
//            }
//
//        navigateToTemplate()
        

        
    }

    override func viewDidAppear(_ animated: Bool) {
      
    }
    
//    func checkIfLoggedIn()
//    {
//        if let authtoken = AppDelegate.authenticationToken {
//            adminTabBarController()
//        }
//        else
//        {
//            createTabBarController()
//        }
//        
//    }
    
//    func createTabBarController() {
//        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        //        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginID")
//        //
//        
//        //viewTabar.removeFromSuperview()
//        
//        viewTabar = (AppDelegate.userTab?.view)!
//        tabBarCnt.tabBar.tintColor = UIColor.black
//        //
//        //        let firstVc = UIViewController()
//        //        firstVc.title = "First"
//        //        firstVc.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "icon"), tag: 0)
//        //        let secondVc = loginVC
//        //        secondVc.title = "Second"
//        //        secondVc.tabBarItem = UITabBarItem.init(title: "Login", image: UIImage(named: "login"), tag: 0)
//        //
//        
//        //tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
//        self.view.viewWithTag(1)
//        self.view.addSubview(viewTabar)
//    }
//    
//    func adminTabBarController()
//    {
////        if(tabBarCnt.view != nil && !tabBarCnt.view.isHidden)
////        {
////            tabBarCnt.view.removeFromSuperview()
////        }
////
////        tabBarCnt.tabBar.tintColor = UIColor.green
////        let controllerArray = TabBarHelper.createAdminTabBar()
////        tabBarCnt.viewControllers = controllerArray.map{UINavigationController.init(rootViewController: $0)}
//        
//        viewTabar = (AppDelegate.adminTab?.view)!
//        self.view.addSubview(viewTabar)
//    }
    
    private func navigateToTemplate () {
        

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let adminNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as? FormTemplateViewController else { return }
        
        self.navigationController?.pushViewController(adminNavigationVC, animated: true)
    }
    
}
