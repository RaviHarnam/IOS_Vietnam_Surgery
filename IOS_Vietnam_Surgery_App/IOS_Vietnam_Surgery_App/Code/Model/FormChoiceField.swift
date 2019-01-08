//
//  FormChoiceField.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/29/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormChoiceField : FormField {
    public var options : [String]?
    
    enum CodingKeys : String, CodingKey {
        case options = "Options"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        options = try container.decodeIfPresent([String].self, forKey: .options)
        try super.init(from: decoder)
        //let superdecoder = try container.superDecoder()        
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(options, forKey: .options)
        try super.encode(to: encoder)
    }
    
    override init() {
        super.init()
    }
}
