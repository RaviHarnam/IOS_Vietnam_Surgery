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
    
    //@IBOutlet weak var LoginSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var UsernameField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBOutlet weak var ValidationMessageLabel: UILabel!
    private var spinner : UIActivityIndicatorView?
    
    private var isFetching : Bool = false {
        didSet {
            if isFetching {
                spinner?.show()
            }
            else {
                spinner?.hide()
            }
        }
    }
    
    private func ValidationMessageToggle(toggleValue: Bool) {
        ValidationMessageLabel.isHidden = toggleValue
    }
    
    func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        self.spinner = spinner
        view.addSubview(spinner)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.storyboard?.instantiateViewController(withIdentifier: "LoginID")
//        LoginSpinner.isHidden = true
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        self.UsernameField.addTarget(self, action: #selector(usernameValueChanged), for: .editingChanged)
        self.PasswordField.addTarget(self, action: #selector(passwordValueChanged), for: .editingChanged)
        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Login"
        ValidationMessageLabel.isHidden = true
        ValidationMessageLabel.textColor = UIColor.red
        //setupSpinner()
        setupLoginPlaceHolders()
        setupNavigationBar()
        #if DEBUG
            UsernameField.text = "test@test.nl"
            PasswordField.text = "Test01!"
        #endif
    }
    
    func setupLoginPlaceHolders() {
        UsernameField.placeholder = "Fill in username"
        UsernameField.autocorrectionType = .no
        PasswordField.autocorrectionType = .no
        PasswordField.isSecureTextEntry = true
        PasswordField.placeholder = "Fill in password"
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Login", comment: ""), style: .plain, target: self, action: #selector(loginClicked))
    }
    
    @objc func usernameValueChanged ()
    {
        self.UsernameField.layer.borderWidth = 0
        self.UsernameField.layer.borderColor = nil
    }
    
    @objc func passwordValueChanged ()
    {
        self.PasswordField.layer.borderWidth = 0
        self.PasswordField.layer.borderColor = nil
    }
    
    @objc func loginClicked() {
        guard validateCredentials() else {
            return
        }
        isFetching = true
        UserLogin()
    }
    

    func UserLogin() {
        if (BaseAPIManager.isConnectedToInternet()) {
            isFetching = true
            let filledInLogin = Login(username: UsernameField.text, password: PasswordField.text, grant_type: "password")
            UserManager.UserLogIn(login: filledInLogin, callBack: {
                (result) in
                self.isFetching = false
                if(result) { //Succesfully logged in, appbar will do nav for us
                    print("Wat zit er in result: ", result)
                    //self.navigateToAdminInterface()∫
                }
                else {
                    print("Waarde result: ", result)
                    self.UsernameField.layer.borderWidth = 1
                    self.UsernameField.layer.borderColor = UIColor.red.cgColor
                    self.PasswordField.layer.borderWidth = 1
                    self.PasswordField.layer.borderColor = UIColor.red.cgColor
                }
            })
        }
        else {
            let alert = AlertHelper.noInternetAlert()
            self.present(alert, animated: true)
        }
    }
    
    func validateCredentials() -> Bool {
        ValidationMessageLabel.isHidden = true
        
        guard let email = UsernameField.text, !email.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterUserName", comment: "")
            return false
        }
        
        guard let password = PasswordField.text, !password.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterPassword", comment: "")
            return false
            
        }
        return true
    }
        
    
//    private func navigateToAdminInterface () {
//
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let adminNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
//        print("navigating to usertable with: " + self.navigationController.debugDescription)
//        navigationController!.pushViewController(adminNavigationVC, animated: true)
//    }
}
