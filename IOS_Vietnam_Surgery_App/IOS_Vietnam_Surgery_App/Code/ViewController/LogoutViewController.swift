//
//  LogoutViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 10/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

   public var loggingOut = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        alertForLogout()
    }
    
    public func alertForLogout() {
        let alert = UIAlertController(title: NSLocalizedString("LogOut", comment: ""), message: NSLocalizedString("LogoutMsg", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
            (action: UIAlertAction) in
            self.logOut(logginOut: self.loggingOut)
            }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment:""), style: .cancel, handler: {
            (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    public func logOut(logginOut: Bool) {
        if(logginOut) {
            AppDelegate.authenticationToken = nil
            AppDelegate.userRole = nil
            AppDelegate.userName = nil
        }
    }
}