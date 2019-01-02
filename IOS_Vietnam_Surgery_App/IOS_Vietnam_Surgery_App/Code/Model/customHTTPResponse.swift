//
//  customHTTPResponse.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 13/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

<<<<<<< HEAD
public class customHTTPResponse : Codable
{
=======
public class customHTTPResponse : Codable {
>>>>>>> 6c3c713318e540e99535ee3d071681a4cd61c4bd
    var succes: Bool
    var message : String
    
    enum CodingKeys : String, CodingKey {
        case succes = "Success"
        case message = "Message"
    }
}
