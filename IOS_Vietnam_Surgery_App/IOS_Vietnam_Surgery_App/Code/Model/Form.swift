//
//  FormTemplate.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class Form : Codable {
    public var id : Int?
    public var name : String?
    public var region : String?
    public var formTemplate : String?
    public var formContent : [FormContentKeyValuePair]?
    
    public var formPictures : [UIImage] = []
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
        case region = "Region"
        case formTemplate = "FormTemplate"
        case formContent = "FormContent"
    }
}
