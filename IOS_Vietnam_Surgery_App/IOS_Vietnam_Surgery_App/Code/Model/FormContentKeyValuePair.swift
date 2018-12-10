//
//  FormContentKeyValuePair.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/8/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormContentKeyValuePair : Codable {
    public var name : String?
    public var value : String?
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    enum CodingKeys : String, CodingKey {
        case name = "Name"
        case value = "Value"
    }
}
