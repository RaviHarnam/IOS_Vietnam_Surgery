//
//  AuthenticationToken.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class AuthenticationToken : Codable {
    
    var authenticationtoken : String?
    var tokentype : String?
    var expiresin : Int?
    var username : String?
    var issued : String?
    var expires: String?
    
    
    enum CodingKeys : String, CodingKey {
        case authenticationtoken = "access_token"
        case tokentype = "token_type"
        case expiresin = "expires_in"
        case username = "userName"
        case issued = ".issued"
        case expires = ".expires"
    }
    
}
