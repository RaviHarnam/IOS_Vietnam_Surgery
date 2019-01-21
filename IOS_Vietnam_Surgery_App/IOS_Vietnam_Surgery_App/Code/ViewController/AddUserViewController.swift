//
//  AddUserViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 25/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    private var option : String?
    public var callback : CallbackProtocol?
    private var spinner : UIActivityIndicatorView?
    private var isClicked : Bool = false
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var RightsLabel: UILabel!
    
    @IBOutlet weak var ValidationMessageLabel: UILabel!
    
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var ConfirmPasswordLabel: UILabel!
    
    @IBOutlet weak var UserNameTextView: UITextField!
    
    @IBOutlet weak var PasswordTextView: UITextField!
    
    @IBOutlet weak var OptionUISegmentedControl: UISegmentedControl!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add User"
        
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        setupNavigationBar()
        setupLabels()
    }
    
    private func sucessfullyAddedMessage(email: String) {
        
        let usermessage = "User " + email + " added successfully"
        let alert = UIAlertController(title: "Success ", message: usermessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) in
            
             self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func ValidationMessageToggle(toggleValue: Bool) {
        ValidationMessageLabel.isHidden = toggleValue
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
        guard validateForm() else {
            return
        }
        
        let registerModel = Register(password: PasswordTextView.text, confirmpassword: PasswordTextView.text, userrole: self.OptionUISegmentedControl.titleForSegment(at: self.OptionUISegmentedControl.selectedSegmentIndex), email: UserNameTextView.text)
        
        registerUser(registerModel: registerModel)
//                spinner?.show()
//                UserManager.Register(register: registerModel, callbackUser: {
//                    (user) in
//                    self.spinner?.hide()
//                    if let registereduser = user {
//                        self.callback?.setValue(data: registereduser)
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    else {
//                        self.alerMessageUserAddFailed()
//                    }
//                })
    }
    
    private func validateForm() -> Bool {
        ValidationMessageLabel.isHidden = true
        
        
        guard let email = UserNameTextView.text, !email.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterUserName", comment: "")
            return false
        }
        
        guard checkEmailWithRegex(email: email) else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EmailRegex", comment: "")
            return false
        }
        
        guard let password = PasswordTextView.text, !password.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterPassword", comment: "")
            return false
        }
        
        guard let confirmpassword = ConfirmPasswordTextField.text, !confirmpassword.isEmpty else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("EnterConfirmPassword", comment: "")
            return false
        }
        guard checkIfPasswordIsEqualToConfirmPassword(password: password, confirmpassword: confirmpassword) else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("PasswordNotEqual", comment: "")
            return false
        }
        guard checkPasswordWithRegex(password: password) else {
            ValidationMessageToggle(toggleValue: false)
            ValidationMessageLabel.text = NSLocalizedString("PasswordRegex", comment: "")
            return false
        }
       return true
    }
    
    func registerUser(registerModel: Register) {
       
        spinner?.show()
        UserManager.Register(register: registerModel, callbackUser: {
            (user) in
            
            self.spinner?.hide()
            if let registereduser = user {
                self.callback?.setValue(data: registereduser)
                self.sucessfullyAddedMessage(email: registerModel.email!)
            }
            else {
                self.alerMessageUserAddFailed()
            }
        })
    }
    
  
    private func checkPasswordWithRegex (password: String) -> Bool {
        let pattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*-=()_+]).{6,}$"
        let result = password.range(of: pattern , options: .regularExpression) != nil
        
        return result
    }
    
    private func checkEmailWithRegex(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = email.range(of: pattern, options: .regularExpression) != nil
        
        return result
    }
    
    private func checkIfPasswordIsEqualToConfirmPassword (password: String, confirmpassword: String) -> Bool {
        
         return password.elementsEqual(confirmpassword)
       
    }
    private func alerMessageUserAddFailed () {
        let useraddedfailedmessage = NSLocalizedString("UserAddedFailed", comment: "")
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: useraddedfailedmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
