//
//  UserTableViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 18/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class UserTableViewController : UITableViewController {
    

    var users: [User]?
    
    @IBOutlet weak var UserTableView: UITableView!
    
        override public func viewDidLoad () {
      
        super.viewDidLoad()
            
        setupTableView()
        
        
    }
    
    func setupTableView()
    {
        UserTableView.dataSource = self
        UserTableView.delegate = self
        setupNavigationBarItems()
        getAllUsers()
    }
    
    func setupNavigationBarItems()
    {
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: UIBarButtonItem.Style.plain, target: self, action: nil)

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
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        if let userarray = self.users {
            
            var user = userarray[indexPath.row]
           
            cell.textLabel?.text = user.username
        }
        return cell
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
}
