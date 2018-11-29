//
//  FormList.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/29/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormTemplate : Codable {
    public var sections : [FormSection]?
    
    enum CodingKeys : String, CodingKey {
        case sections = "Sections"
    }
}
