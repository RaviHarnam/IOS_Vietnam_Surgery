//
//  customHTTPResponse.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 13/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class customHTTPResponse : Codable
{
    public var succes: Bool
    public var message : String
    
    enum CodingKeys : String, CodingKey {
        case succes = "Success"
        case message = "Message"
    }
}
