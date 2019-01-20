//
//  FormTemplatePlusContent.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 19/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class FormTemplatePlusContent : Codable {
    
    public var id : Int?
    public var region : String?
    public var name : String?
    public var formtemplate : String?
    public var formcontent : FormContentApiModel?
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case region = "Region"
        case name = "Name"
        case formtemplate = "FormTemplate"
        case formcontent = "FormContentApiModel"
    }
}
