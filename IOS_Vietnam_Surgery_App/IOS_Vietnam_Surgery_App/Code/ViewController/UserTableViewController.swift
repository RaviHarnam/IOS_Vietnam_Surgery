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
    
    private let refreshControl = UIRefreshControl()

    var users: [User]?
    
    private var dataChanged = false
    
    
    
    @IBOutlet weak var UserTableView: UITableView!
    
        override public func viewDidLoad () {
            super.viewDidLoad()
            //let ctrl = TabBarHelper.createAdminTabBar()
            //self.view.addSubview(ctrl.view)
            setupTableView()
            print("Usertableview aangeroepen")
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.UserTableView.reloadData()
            }
            dataChanged = false
        }
    }
    
    func setupTableView() {
        UserTableView.register(UINib(nibName: "UserOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "UserOverviewTableViewCell")
        UserTableView.dataSource = self
        UserTableView.refreshControl = refreshControl
        UserTableView.addSubview(refreshControl)
        //UserTableView.delegate = self
        setupNavigationBarItems()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        getAllUsers()
    }
    
   @objc func refresh() {
        getAllUsers()
        self.refreshControl.endRefreshing()
    }
    
    func getUserName(userGuid: String)
    {
        if let users = self.users {
            
        }
    }
    func setupNavigationBarItems()
    {
        if let username = AppDelegate.userName {
        
            navigationItem.title = "Logged in " + username
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(alertForLogout))

//        let addUserButton = UIButton(type: .system)
//        addUserButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        addUserButton.setTitle("Add User", for: .disabled)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addUserButton)
        
        
    }
    @objc func addTapped()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addUserVC = storyboard.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        addUserVC.callback = self
         self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
//    public func alertForDeleteUser() {
//
//        var alert = UIAlertController(title: NSLocalizedString("DeleteUser", comment: ""), message: NSLocalizedString("DeleteUserMsg ", comment: ""), preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//
//
//
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//
//    }
    
    public func getAllUsers()
    {
        UserManager.getAllUsers(callBack: {
            (usersArray)  in
            if let users = usersArray  {
                self.users = users
                DispatchQueue.main.async {
                    self.UserTableView.reloadData()
                }
            }
        })
    }
    
    func deleteUser(_ row: Int) {
        guard let token = AppDelegate.authenticationToken else { return }
        UserAPIManager.DeleteUser(token: token, userid: self.users![row].userid!).response(completionHandler: {
            (response) in
            if response.response?.statusCode == 200 {
                self.users?.remove(at: row)
                self.UserTableView.reloadData()
            }
            else {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error_deleting_user", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
    
    @objc func alertForLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
    
            self.LogOut()
   
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    
        self.present(alert, animated: true)
    
    }
    
     public func LogOut()
    {
        print("AuthToken heeft waarde: " , AppDelegate.authenticationToken)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //       let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: RegisterViewController.tokenkey)

        AppDelegate.authenticationToken = nil
        AppDelegate.userRole = nil
        print("AuthToken heeft waarde: " , AppDelegate.authenticationToken)
       // self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
    
extension UserTableViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOverviewTableViewCell", for: indexPath) as! UserOverviewTableViewCell
        
        if let userarray = self.users {
            
            let user = userarray[indexPath.row]
           
            cell.UserNameLabel.text = user.email
            //cell.editUserImage.image = UIImage(named: "Edit-User")
            //cell.deleteUserImage.image = UIImage(named: "Delete")
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(alertForDeleteUser(sender: )))
            //cell.deleteUserImage.isUserInteractionEnabled = true
            //cell.deleteUserImage.tag = indexPath.row
            //cell.deleteUserImage.addGestureRecognizer(singleTap)
        }
        return cell
    }
    
    //Action
    @objc func tapDetected(sender: UITapGestureRecognizer) {
        if let row = sender.view?.tag {
             if let id = self.users?[row].userid {
                guard let token = AppDelegate.authenticationToken else { return }
                UserAPIManager.DeleteUser(token: token, userid: id).response(completionHandler: {
                    (response) in
                    if response.response?.statusCode == 200 {
                        self.users?.remove(at: row)
                        self.UserTableView.reloadData()
                    }
                    else {
                        //Alert
                    }
                })
                print("Delete Clicked on: ", row)
            }
          
        }
    }
    
    
    
    @objc public func alertForDeleteUser(sender: UITapGestureRecognizer) {
        if let row = sender.view?.tag {
            if let name = self.users?[row].email {
                
                let alert = UIAlertController(title: NSLocalizedString("DeleteUser", comment: ""), message: NSLocalizedString("DeleteUserMsg" , comment: "") +  name + "?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.tapDetected(sender: sender)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }

        
    }
     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(self.users?.count ?? 0)
            return self.users?.count ?? 0
    }
}

extension UserTableViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.users?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = user
            vc.callback = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Confirm_delete_user", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in self.deleteUser(indexPath.row) }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension UserTableViewController : CallbackProtocol {
    public func setValue(data: Any) {
        if let user = data as? User {
            if let idx = self.users!.firstIndex(where: { $0.email == user.email }) {
                self.users![idx] = user
                self.dataChanged = true
            }
        }
        else {
            getAllUsers()
            self.dataChanged = true
            //self.users?.append(data as! Register)
        }
    }
}
