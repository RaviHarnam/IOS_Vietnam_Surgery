//
//  LoggedInDelegate.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 03/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public protocol LoggedInDelegate {
    func loggedIn(_ isAdmin: Bool)
    
    func loggedOut()
}

public class LoggedInDelegateNotifier {
    public static var delegate : LoggedInDelegate?
    
    public static func notifyLoggedIn(_ isAdmin: Bool) {
        self.delegate?.loggedIn(isAdmin)
    }

    public static func notifyLoggedOut() {
        self.delegate?.loggedOut()
    }
    
}

