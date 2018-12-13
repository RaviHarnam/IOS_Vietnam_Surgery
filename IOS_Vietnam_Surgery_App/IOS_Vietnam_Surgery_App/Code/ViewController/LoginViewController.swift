//
//  LoginViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBAction func LoginButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.storyboard?.instantiateViewController(withIdentifier: "LoginID")
        view.backgroundColor = UIColor.green
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Login"
       
    }
}
