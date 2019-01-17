//
//  UserDetailViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 09/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userEmailLabel: UILabel!

    
    @IBOutlet weak var userRightsLabel: UILabel!
    
 
    @IBOutlet weak var userEmailTextField: UITextField!
    
  
    @IBOutlet weak var rightsSegmentedControl: UISegmentedControl!
    
    public var callback : CallbackProtocol?
    
    public var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupNavigationItems()
        
    }
    
 
    public func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked))
    }
    

    public func setupLabels () {
        userEmailLabel.text = NSLocalizedString("Email", comment: "") 
        userRightsLabel.text = NSLocalizedString("Rights", comment: "")
        userEmailTextField.text = user?.email
        rightsSegmentedControl.removeAllSegments()
        rightsSegmentedControl.insertSegment(withTitle: NSLocalizedString("AdminOption", comment: ""), at: 0, animated: true)
        rightsSegmentedControl.insertSegment(withTitle: NSLocalizedString("UserOption", comment: ""), at: 1, animated: true)
        rightsSegmentedControl.selectedSegmentIndex = user?.userrole == nil ? 0 : user?.userrole!.first?.roleid == "1" ? 0 : 1
    }
    
    @objc func saveClicked() {
        changeEmailAndRights()
    }
    
    public func changeEmailAndRights () {
        //user?.email = self.userEmailTextField.text
        //user?.roles = []
        //user?.roles.append(Role())
        
        let putModel = UserPutModel()
        putModel.email = self.userEmailTextField.text
        putModel.role = self.rightsSegmentedControl.titleForSegment(at: rightsSegmentedControl.selectedSegmentIndex)
        
        //user?.role = self.rightsSegmentedControl.titleForSegment(at: rightsSegmentedControl.selectedSegmentIndex)
        UserAPIManager.EditUser(token: AppDelegate.authenticationToken!, user: putModel, userId: (self.user?.userid!)!).responseData(completionHandler: {
            (response) in
            print(response)
           
            if response.response?.statusCode == 200 {
                //let decoder = JSONDecoder()
                //let userDB = try? decoder.decode(User.self, from: response.data!)
                self.user?.email = putModel.email
                
                self.callback?.setValue(data: self.user!)
                self.navigationController!.popViewController(animated: true)
            }
        })
    }

}
