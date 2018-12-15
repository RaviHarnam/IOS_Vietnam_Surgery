//
//  User.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 14/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class User {
    
    var username : String?
    var userrole : String?
    
    
    enum CodingKeys : String, CodingKey
    {
        case username = "Username"
        case userrole = "UserRole"
    }
    
}
