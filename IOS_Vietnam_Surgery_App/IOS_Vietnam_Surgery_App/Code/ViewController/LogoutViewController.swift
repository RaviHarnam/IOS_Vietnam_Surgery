//
//  LogoutViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 10/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
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
                self.logOut()
            }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment:""), style: .cancel, handler: {
            (action: UIAlertAction) in
            self.tabBarController?.selectedIndex = 0
        }))
        self.present(alert, animated: true)
    }
    
    public func logOut() {
        
            AppDelegate.authenticationToken = nil
            AppDelegate.userRole = nil
            AppDelegate.userName = nil
    }
}
