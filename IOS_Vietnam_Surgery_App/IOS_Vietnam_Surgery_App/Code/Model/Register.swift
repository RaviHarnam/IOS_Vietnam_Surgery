//
//  Register.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class Register : Codable {
    
    var username : String?
    var password : String?
    var confirmpassword : String?
    var userrole : String?
    var email: String?
    
    init(username: String?, password: String?, confirmpassword: String?, userrole: String?, email: String?) {
        self.username = username
        self.password = password
        self.confirmpassword = confirmpassword
        self.userrole = userrole
        self.email = email
    }
    
    enum CodingKeys : String, CodingKey {
        case username = "Username"
        case password = "Password"
        case confirmpassword = "ConfirmPassword"
        case userrole = "UserRole"
        case email = "Email"
    }
}
