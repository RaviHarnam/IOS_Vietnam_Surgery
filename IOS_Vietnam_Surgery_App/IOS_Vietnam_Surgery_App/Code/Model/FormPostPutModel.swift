//
//  FormPostPutModel.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 1/7/19.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class FormPostPutModel : Codable {
    public var name : String?
    public var region : String?
    public var formTemplate : String?
    //formContent
    
    enum CodingKeys : String, CodingKey {
        case name = "Name"
        case region = "Region"
        case formTemplate = "FormTemplate"
    }
}
