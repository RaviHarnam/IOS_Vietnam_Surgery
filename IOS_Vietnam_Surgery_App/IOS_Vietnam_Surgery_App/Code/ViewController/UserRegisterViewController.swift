//
//  UserRegisterViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 21/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import Eureka
import UIKit

public class UserRegisterViewController : Eureka.FormViewController {

    @IBOutlet weak var validationMessage: UILabel!
    
    private var spinner : UIActivityIndicatorView?
    public var callback : CallbackProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupNavigationBar()
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.title = NSLocalizedString("AddUser", comment: "")
        validationMessage.text = NSLocalizedString("RequiredFields", comment: "")
        
        DispatchQueue.main.async {
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.validationMessage.bottomAnchor, constant: 16).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16).isActive = true
        }
    }
    
    func setupNavigationBar () {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked))
    }
    
    private func ValidationMessageToggle(toggleValue: Bool) {
        validationMessage.isHidden = toggleValue
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
    
    
    @objc func saveClicked() {
        guard validateForm() else {
            return
        }
        
        let password = (self.form.rowBy(tag: "Password") as! PasswordRow).value
        let confirmPassword = (self.form.rowBy(tag: "ConfirmPassword") as! PasswordRow).value
        let email = (self.form.rowBy(tag: "Email") as! EmailRow).value
        let role = (self.form.rowBy(tag: "Rights") as! SegmentedRow<String>).value
        
        let registerModel = Register(password: password, confirmpassword: confirmPassword, userrole: role, email: email)
        registerUser(registerModel: registerModel)
    }
    
    
    func registerUser(registerModel: Register) {
        spinner?.show()
        UserManager.Register(register: registerModel, callbackUser: {
            (user) in
            
            self.spinner?.hide()
            if let registereduser = user {
                self.callback?.setValue(data: registereduser)
                //self.sucessfullyAddedMessage(email: registerModel.email!)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.alertAddingUserFailed()
            }
        })
    }
    
    private func alertAddingUserFailed() {
        let useraddedfailedmessage = NSLocalizedString("UserAddedFailed", comment: "")
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: useraddedfailedmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupForm() {
        let section = Section ()
        section.append(EmailRow(){
            $0.title = NSLocalizedString("Email", comment: "")
            $0.placeholder = NSLocalizedString("Email", comment: "")
            $0.tag = "Email"
            $0.validationOptions = .validatesOnDemand
            $0.add(rule: RuleEmail(msg: $0.tag!, id: $0.tag))
            $0.add(rule: RuleRequired(msg: $0.tag!, id: $0.tag))
            //$0.add(rule: RuleRegExp(regExpr: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", msg: $0.tag!))
        })
        section.append(PasswordRow(){
            $0.title = NSLocalizedString("Password", comment: "")
            $0.placeholder = NSLocalizedString("EnterPassword", comment: "")
            $0.tag = "Password"
            $0.validationOptions = .validatesOnDemand
            $0.add(rule: RuleRequired(msg: $0.tag!, id: $0.tag))
            $0.add(rule: RuleRegExp(regExpr: "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*-=()_+]).{6,}$", msg: $0.tag!))
            
        })
        section.append(PasswordRow(){
            $0.title = NSLocalizedString("ConfirmPassword", comment: "")
            $0.placeholder = NSLocalizedString("EnterConfirmPassword", comment: "")
            $0.tag = "ConfirmPassword"
            $0.validationOptions = .validatesOnDemand
            $0.add(rule: RuleRequired(msg: $0.tag!, id: $0.tag))
            $0.add(rule: RuleRegExp(regExpr: "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*-=()_+]).{6,}$", msg: $0.tag!))
            
        })
        section.append(SegmentedRow<String>(){
            $0.title = NSLocalizedString("Rights", comment: "")
            $0.selectorTitle = NSLocalizedString("Rights", comment: "")
            $0.tag = "Rights"
            $0.validationOptions = .validatesOnDemand
            $0.add(rule: RuleRequired(msg: $0.tag!, id: $0.tag))
            $0.options = [NSLocalizedString("Admin", comment: ""), NSLocalizedString("User", comment: "")]
            $0.value = $0.options?.first
        })
        
        self.form.append(section)
    }
    
    func validateForm() -> Bool {
        let errors = self.form.validate()
        var valid = errors.isEmpty
        if !valid {
            for error in errors {
                self.form.rowBy(tag: error.msg)?.baseCell.textLabel?.textColor = UIColor.red
            }
        }
        
        let password = (form.rowBy(tag: "Password") as! PasswordRow).value ?? ""
        let confirmPassword = (form.rowBy(tag: "ConfirmPassword") as! PasswordRow).value ?? ""
        
        if !password.elementsEqual(confirmPassword) {
            valid = false
        }
        return valid
    }
    
    
}
