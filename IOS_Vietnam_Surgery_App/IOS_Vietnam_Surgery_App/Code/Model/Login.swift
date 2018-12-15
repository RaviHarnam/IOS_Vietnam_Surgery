//
//  Login.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class Login : Codable {
    
    var username : String?
    var password : String?
    
    init(username: String?, password: String?) {
        
        self.username = username
        self.password = password
        
    }
    
    enum CodingKeys : String, CodingKey
    {
        case username = "Username"
        case password = "Password"
    }
}
