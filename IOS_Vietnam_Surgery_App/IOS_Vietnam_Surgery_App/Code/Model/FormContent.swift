//
//  FormContent.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 08/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//


import Foundation
import UIKit

public class FormContent : Codable {
    
    public var formid : Int?
    public var formContent : [FormContentKeyValuePair]?
    public var images : [[UInt8]]? = []
    public var formTemplateName : String?
    
    init(formid: Int?, formContent: [FormContentKeyValuePair], images: [[UInt8]]) {
       self.formid = formid
       self.formContent = formContent
       self.images = images
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        formid = try container.decode(Int?.self, forKey: .formid)
        formContent = try container.decode(([FormContentKeyValuePair]?).self, forKey: .formContent)
        images = try container.decodeIfPresent(([[UInt8]]).self, forKey: .images)
        formTemplateName = try container.decodeIfPresent(String.self, forKey: .formTemplateName)
    }
    
    public func encoder(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(formid, forKey: .formid)
        try container.encode(formContent, forKey: .formContent)
        try container.encode(images, forKey: .images)
        try container.encode(formTemplateName, forKey: .formTemplateName)
    }
    
    init() {
        
    }
    
    enum CodingKeys : String, CodingKey {
        case formid = "Id"
        case formContent = "FormContent"
        case images = "Images"
        case formTemplateName = "FormTemplateName"
    }
}
