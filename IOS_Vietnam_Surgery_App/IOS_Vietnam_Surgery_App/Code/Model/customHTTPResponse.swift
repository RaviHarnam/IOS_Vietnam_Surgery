//
//  customHTTPResponse.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 13/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

import Foundation

public class customHTTPResponse : Codable
{
    var succes: Bool
    var message : String
    
    enum CodingKeys : String, CodingKey
    {
        case succes = "Success"
        case message = "Message"
        
    }
}
