//
//  Role.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 16/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class Role : Codable {
    
    var userid : String?
    var roleid : String?
    
    enum CodingKeys : String, CodingKey
    {
        case userid = "UserId"
        case roleid = "RoleId"
    }
}
