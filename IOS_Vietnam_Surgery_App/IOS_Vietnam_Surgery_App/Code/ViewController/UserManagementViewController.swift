//
//  UserManagementViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 17-01-19.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class UserManagementViewController : UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    var users: [User]?
    
    private var dataChanged = false
    
    @IBOutlet weak var userTableView: UITableView!
    
    private var filteredUserData : [User] = []
    public var searchBar: UISearchBar?
    let searchController = UISearchController(searchResultsController: nil)
    
    private var spinner : UIActivityIndicatorView?
    
    override public func viewDidLoad () {
        super.viewDidLoad()
        
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        self.title = NSLocalizedString("UserManagementViewControllerTabTitle", comment: "")
        setupTableView()
        setupSearchBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        getAllUsers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
            dataChanged = false
        }
    }
    
    func setupSearchBar () {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search on name only"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func setupTableView() {
        userTableView.register(UINib(nibName: "UserOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "UserOverviewTableViewCell")
        userTableView.dataSource = self
        userTableView.refreshControl = refreshControl
        userTableView.addSubview(refreshControl)
        userTableView.delegate = self
        setupNavigationBarItems()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        userTableView.rowHeight = 62
    }
    
    @objc func refresh() {
        getAllUsers()
        self.refreshControl.endRefreshing()
    }
    
    func setupNavigationBarItems()
    {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    @objc func addTapped()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addUserVC = storyboard.instantiateViewController(withIdentifier: "UserRegisterViewController") as! UserRegisterViewController
        addUserVC.callback = self
        self.navigationController?.pushViewController(addUserVC, animated: true)
    }
    
    
    public func getAllUsers()
    {
        self.spinner?.show()
        UserManager.getAllUsers(callBack: {
            (usersArray) in
            self.spinner?.hide()
            if let users = usersArray  {
                self.users = users
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        })
    }
    
    func deleteUser(_ row: Int) {
        self.spinner?.show()
        guard let token = AppDelegate.authenticationToken else { return }
        UserAPIManager.DeleteUser(token: token, userid: self.users![row].userid!).response(completionHandler: {
            (response) in
            self.spinner?.hide()
            if response.response?.statusCode == 200 {
                self.users?.remove(at: row)
                self.userTableView.reloadData()
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
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        print(self.users?.count)
        if let users = self.users {
            
            filteredUserData = users.filter({( user : User) -> Bool in
                let searchText = searchText.lowercased()
                print("SearchText: ", searchText)
                
                var email = user.email?.lowercased()
                print("Email is: ", email)
                
                var role : String? = nil
                if let roleid = user.userrole?.first?.roleid {
                    role = (roleid.elementsEqual("1") ? NSLocalizedString("UserRoleAdmin", comment: "") : NSLocalizedString("UserRoleUser", comment: "")).lowercased()
                    print("Role is: ", role)
                }
                var ValueForFilteredObj = email?.contains(searchText) ?? false
                print ("ValueForFilteredObj: ", ValueForFilteredObj)
                return (email?.contains(searchText) ?? false) || (role?.contains(searchText) ?? false)
            })
        }
        
        print(filteredUserData.count)
        
        DispatchQueue.main.async {
            self.userTableView.reloadData()
        }
    }
}

extension UserManagementViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOverviewTableViewCell", for: indexPath) as! UserOverviewTableViewCell
        
        let user = isFiltering() ? filteredUserData[indexPath.row] : users![indexPath.row]
            
            cell.UserNameLabel.text = user.email
            
            if let role = user.userrole?.first {
                if(role.roleid == "1") {
                    cell.userRoleLabel.text = NSLocalizedString("UserRoleAdmin", comment: "")
                }
                else {
                    cell.userRoleLabel.text = NSLocalizedString("UserRoleUser", comment: "")
                }
            }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.users?.count ?? 0)
        return isFiltering() ? filteredUserData.count : users?.count ?? 0
    }
}

extension UserManagementViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.users?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            vc.user = user
            vc.callback = self
            vc.userNumber = indexPath.row
            vc.isCurrentLoggedInUser = user.username!.elementsEqual(AppDelegate.userName ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.users![indexPath.row].username == AppDelegate.userName {
                //alert tonen
                let alert = AlertHelper.errorAlert()
                self.present(alert, animated: true)
                
                return
            }
            
            let alert = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Confirm_delete_user", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in self.deleteUser(indexPath.row) }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension UserManagementViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    public func updateSearchResults(for searchController: UISearchController) {
        //        guard 1 == 2 else {
        //            return
        //        }
        if !searchController.searchBar.text!.isEmpty {
            filterContentForSearchText(searchController.searchBar.text!)
        } else {
            
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
            
        }
        
    }
}

extension UserManagementViewController : CallbackProtocol {
    public func setValue(data: Any) {
        if let user = data as? User {
           self.users?.append(user)
            self.dataChanged = true
        }
        else if let userDic = data as? [Int:User] {
            let kvp = userDic.first
            self.users![kvp!.key] = kvp!.value
            self.dataChanged = true
        }
    }
}
