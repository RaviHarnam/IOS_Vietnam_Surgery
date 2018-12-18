//
//  User.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 14/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class User : Codable {
    
    var email : String?
    var userrole : [Role]?
    var userid : String?
    var username : String?
    
    
    enum CodingKeys : String, CodingKey
    {
        case email = "Email"
        case userrole = "Roles"
        case userid = "Id"
        case username = "UserName"
    }
    
}
