//
//  LoginViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    public static let tokenkey = "AuthenticationToken"
    
    @IBOutlet weak var LoginSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBAction func LoginButton(_ sender: Any) {
        if(LoginSpinner.isHidden == true)
        {
            LoginSpinner.isHidden = false
            LoginSpinner.startAnimating()
            UserLogin()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.storyboard?.instantiateViewController(withIdentifier: "LoginID")
        LoginSpinner.isHidden = true
        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Login"
        
       setupLoginPlaceHolders()
    }
    
    
    func setupLoginPlaceHolders() {
        
        UsernameField.placeholder = "Fill in username"
        UsernameField.autocorrectionType = .no
        PasswordField.autocorrectionType = .no
        PasswordField.isSecureTextEntry = true
        PasswordField.placeholder = "Fill in password"
        LoginButton.setTitle("Login", for: .normal)
    }
    
    func UserLogin()
    {
        
        let filledInLogin = Login(username: UsernameField.text, password: PasswordField.text, grant_type: "password")
        UserManager.UserLogIn(login: filledInLogin, callBack: {
            (result) in
            
            if(result)
            {
                self.navigateToAdminInterface()
            }
            else
            {
                
            }
        })
        
       
        if (UserManager.userLogInSuccesfull)
        {
            
            
        }
    }
    
    private func navigateToAdminInterface () {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let adminNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "AdminNavigationController") as? AdminNavigationController else { return }
        
        present(adminNavigationVC, animated: true, completion: nil)
    }
}
