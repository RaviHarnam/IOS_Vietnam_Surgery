//
//  AddUserViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 25/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

   
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var RightsLabel: UILabel!
    
    @IBOutlet weak var ValidationMessageLabel: UILabel!
    
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var ConfirmPasswordLabel: UILabel!
   
    
    @IBOutlet weak var UserNameTextView: UITextField!
    
    private var option : String?
    
    @IBOutlet weak var PasswordTextView: UITextField!
    
    @IBOutlet weak var OptionUISegmentedControl: UISegmentedControl!
    
    public var callback : CallbackProtocol?
    
    private var spinner : UIActivityIndicatorView?
    
    private func alertMessage(email: String) {
        
        let usermessage = "User " + email + " added successfully"
        let alert = UIAlertController(title: "Success ", message: usermessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        
        self.present(alert, animated: true)
    }
    
    private func ValidationMessageToggle(toggleValue: Bool)
    {
        ValidationMessageLabel.isHidden = toggleValue
    }
    

    
//    @IBAction func optionChosen(_ sender: Any) {
//        
//        switch OptionUISegmentedControl.selectedSegmentIndex
//        {
//        case 0:
//            self.option = "Admin"
//            print(option)
//        case 1:
//            self.option = "User"
//            print(option)
//        default:
//            break
//        }
//    }
//    @IBAction func fieldScreenerButtonClick(_ sender: Any) {
////        fieldScreenerButton.setTitleColor(UIColor.white, for: .normal)
//        fieldScreenerButton.isSelected = true
//        adminButton.isSelected = false
////        adminButton.backgroundColor = UIColor.white
//    }
    private var isClicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add User"
        
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        setupNavigationBar()
        setupLabels()
    }
    
    func setupLabels() {
        UserNameLabel.text = "Email"
        PasswordLabel.text = "Password"
        RightsLabel.text = "Rights"
        ConfirmPasswordLabel.text = "Confirm Password"
        ValidationMessageLabel.textColor = UIColor.red
        ValidationMessageLabel.isHidden = true
        OptionUISegmentedControl.removeAllSegments()
        OptionUISegmentedControl.insertSegment(withTitle: NSLocalizedString("AdminOption", comment: ""), at: 0, animated: true)
        OptionUISegmentedControl.selectedSegmentIndex = 0
        OptionUISegmentedControl.insertSegment(withTitle: NSLocalizedString("UserOption", comment: ""), at: 1, animated: true)
        PasswordTextView.autocorrectionType = .no
        PasswordTextView.isSecureTextEntry = true
        ConfirmPasswordTextField.autocorrectionType = .no
        ConfirmPasswordTextField.isSecureTextEntry = true
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked))
    }
    
    @objc func saveClicked() {
        ValidationMessageLabel.isHidden = true
      
        guard let email = UserNameTextView.text, !email.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
             UserNameTextView.layer.borderColor = UIColor.red.cgColor
            ValidationMessageLabel.text = NSLocalizedString("EnterUserName", comment: "")
            return
        }
        
        guard let password = PasswordTextView.text, !password.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterPassword", comment: "")
            return
        }
        
        guard let confirmpassword = ConfirmPasswordTextField.text, !confirmpassword.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterConfirmPassword", comment: "")
            return
        }
        
        
        if (password.elementsEqual(confirmpassword)) {
            alertMessage(email: email)
            let registerModel = Register(password: PasswordTextView.text, confirmpassword: PasswordTextView.text, userrole: self.OptionUISegmentedControl.titleForSegment(at: self.OptionUISegmentedControl.selectedSegmentIndex), email: UserNameTextView.text)
            spinner?.show()
            UserManager.Register(register: registerModel, callbackUser: {
                (user) in
                self.spinner?.hide()
                if let registereduser = user {
                    self.callback?.setValue(data: registereduser)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.alerMessageUserAddFailed()
                }
            })
            //navigationController?.popViewController(animated: true)
        }
        else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("PasswordNotEqual", comment: "")
            return
        }
    }
    
    private func alerMessageUserAddFailed () {
        let useraddedfailedmessage = NSLocalizedString("UserAddedFailed", comment: "")
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: useraddedfailedmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
//    func registerNewUser() {
//        var usersToRegister : Register
//        if(adminButton.isSelected) {
//        usersToRegister = Register(username: UserNameLabel.text, password: PasswordLabel.text, confirmpassword: PasswordLabel.text, userrole:"Admin", email: "bla@nil.nl")
//            UserManager.Register(register: usersToRegister)
//        }
//        else {
//            usersToRegister = Register(username: UserNameLabel.text, password: PasswordLabel.text, confirmpassword: PasswordLabel.text, userrole:"User", email: "bla@nil.nl")
//            UserManager.Register(register: usersToRegister)
//        }
//
//    }
}
