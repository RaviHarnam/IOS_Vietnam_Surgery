//
//  AddUserViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 25/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var RightsLabel: UILabel!
    
    @IBOutlet weak var adminButton: UIButton!
    
    @IBOutlet weak var fieldScreenerButton: UIButton!
    
    
    @IBAction func adminButtonClick(_ sender: Any) {
        
        adminButton.isSelected = true
        fieldScreenerButton.isSelected = false
        
    }
    
    @IBAction func fieldScreenerButtonClick(_ sender: Any) {
//        fieldScreenerButton.setTitleColor(UIColor.white, for: .normal)
        fieldScreenerButton.isSelected = true
        adminButton.isSelected = false
//        adminButton.backgroundColor = UIColor.white
    }
    private var isClicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add User"
        setupLabels()
    }
    
    func setupLabels() {
        NameLabel.text = "Name"
        UserNameLabel.text = "Username"
        PasswordLabel.text = "Password"
        RightsLabel.text = "Rights"
        setupButtonsText()
    }
    
    func setupButtonsText() {
        adminButton.setTitle("Admin", for: .normal)
        fieldScreenerButton.setTitle("User", for: .normal)
    }
    
    func checkButtonClick()
    {
        
    }
    
    func registerNewUser() {
        var usersToRegister : Register
        if(adminButton.isSelected) {
        usersToRegister = Register(username: UserNameLabel.text, password: PasswordLabel.text, confirmpassword: PasswordLabel.text, userrole:"Admin", email: "bla@nil.nl")
            UserManager.Register(register: usersToRegister)
        }
        else {
            usersToRegister = Register(username: UserNameLabel.text, password: PasswordLabel.text, confirmpassword: PasswordLabel.text, userrole:"User", email: "bla@nil.nl")
            UserManager.Register(register: usersToRegister)
        }
        
    }
}
