//
//  FormHeader.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/29/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormSection : Codable {
    public var name : String?
    public var fields : [FormChoiceField]?
    
    enum CodingKeys : String,CodingKey {
        case name = "Name"
        case fields = "Fields"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        fields = try container.decode([FormChoiceField].self, forKey: .fields)
    }
    
    public func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(fields, forKey: .fields)
    }
    
    init() {
        name = ""
        fields = []
    }
}
