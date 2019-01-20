//
//  FormContentApiModel.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 19/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class FormContentApiModel : Codable {

    public var id: Int?
    public var content: String?
    public var formtemplateid : Int?
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case content = "Content"
        case formtemplateid = "FormTemplateId"
    }
}
