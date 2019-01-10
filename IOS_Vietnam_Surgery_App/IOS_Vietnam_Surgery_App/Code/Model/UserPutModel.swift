//
//  UserPutModel.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 10/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class UserPutModel : Codable {
    public var email : String?
    public var role : String?
    
    enum CodingKeys : String, CodingKey {
        case email = "Email"
        case role = "UserRole"
    }
}
