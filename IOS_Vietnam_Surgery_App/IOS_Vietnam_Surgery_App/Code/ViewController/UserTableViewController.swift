//
//  UserTableViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 18/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

public class UserTableViewController : UIViewController {
    
    @objc private let refresh : UIRefreshControl = UIRefreshControl()

    var users: [User]?
    
    @IBOutlet weak var UserTableView: UITableView!
    
        override public func viewDidLoad () {
            super.viewDidLoad()
            //let ctrl = TabBarHelper.createAdminTabBar()
            //self.view.addSubview(ctrl.view)
            setupTableView()
            print("Usertableview aangeroepen")
        
    }
    
    func setupTableView() {
         UserTableView.register(UINib(nibName: "UserOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "UserOverviewTableViewCell")
        UserTableView.dataSource = self
        UserTableView.refreshControl = refresh
        //UserTableView.delegate = self
        setupNavigationBarItems()
    //    refresh.addTarget(self, action: #selector (refresh), for: .valueChanged)
        getAllUsers()
    }
    
//   @objc func refresh() {
//
//    }
    
    func setupNavigationBarItems()
    {
        navigationItem.title = "Logged in: Juriaan Toning"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(LogOut))

//        let addUserButton = UIButton(type: .system)
//        addUserButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        addUserButton.setTitle("Add User", for: .disabled)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addUserButton)
        
        
    }
    @objc func addTapped()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addUserVC = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
         self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
    public func getAllUsers()
    {
        UserManager.getAllUsers(callBack: {
            (usersArray)  in
            
            if let users = usersArray  {
                
                self.users = users
                
                if let userarray = self.users {
                    DispatchQueue.main.async {
                        self.UserTableView.reloadData()
                    }
                    
                    for user in userarray {
                        
                        print("UITABLE: ", user.userid)
                    }
                }
            }
        })
    }
        
    
    @objc func LogOut()
    {
        print("AuthToken heeft waarde: " , AppDelegate.authenticationToken)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //       let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: RegisterViewController.tokenkey)

        AppDelegate.authenticationToken = nil
        AppDelegate.userRole = nil
       // self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
    
extension UserTableViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOverviewTableViewCell", for: indexPath) as! UserOverviewTableViewCell
        
        if let userarray = self.users {
            
            var user = userarray[indexPath.row]
           
            cell.UserNameLabel.text = user.username
        }
        return cell
    }
    
     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(self.users?.count ?? 0)
            return self.users?.count ?? 0
            
            //        if let userarray = self.users
            //        {
            //            print("Komt in tableView Func")
            //            var userstoreturn = userarray
            //            count = userstoreturn.count
            //
            //        }
            //        print("UserCount: ", count)
            //        return count
            //
    }
}

