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
    public var formContent : [FormContentKeyValuePair]? = []
    
    public var formPictures : [UIImage] = []
    public var formImagesBytes : [[UInt8]]? = []  //String? [UInt8] = []
    public var createdOn : String?
    
    
    enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
        case region = "Region"
        case formTemplate = "FormTemplate"
        case formContent = "FormContent"
        case formImagesBytes = "Images"
        case createdOn = "CreatedOn"
    }
    
    enum EncodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
        case region = "Region"
        case formTemplate = "FormTemplate"
        case formContent = "FormContent"
        case formImagesBytes = "Images"
        case createdOn = "CreatedOn"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        region = try container.decode(String.self, forKey: .region)
        formTemplate = try container.decode(String.self, forKey: .formTemplate)
        formContent = try container.decodeIfPresent([FormContentKeyValuePair].self, forKey: .formContent)
        formImagesBytes = try container.decodeIfPresent([[UInt8]].self, forKey: .formImagesBytes)
        createdOn = try container.decodeIfPresent(String.self, forKey: .createdOn)
    }
    
    init() {
        
    }
    
    func encode(encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(region, forKey: .region)
        try container.encode(formTemplate, forKey: .formTemplate)
        try container.encode(formContent, forKey: .formContent)
        try container.encode(formImagesBytes, forKey: .formImagesBytes)
        try container.encode(createdOn, forKey: .createdOn)
    }
}
