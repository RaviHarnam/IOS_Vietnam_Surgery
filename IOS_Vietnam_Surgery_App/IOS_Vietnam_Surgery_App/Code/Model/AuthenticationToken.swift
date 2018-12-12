//
//  AuthenticationToken.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class AuthenticationToken : Codable{
    
    var authenticationtoken : String
    
    enum CodingKeys : String, CodingKey
    {
        case authenticationtoken = "AuthToken"
    }
    
}
