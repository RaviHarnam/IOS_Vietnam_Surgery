//
//  FormField.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/29/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormField : Codable {
    public var name : String?
    public var type : String?
    public var required : String?
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case type = "Type"
        case required = "Required"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        type = try values.decode(String.self, forKey: CodingKeys.type)
        required = try values.decode(String.self, forKey: CodingKeys.required)
    }
    
    init() {
        
    }
}

