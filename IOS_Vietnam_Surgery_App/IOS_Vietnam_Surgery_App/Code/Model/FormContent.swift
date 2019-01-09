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
    public var images : [[UInt8]] = []
    
    init(formid: Int?, formContent: [FormContentKeyValuePair], images: [[UInt8]]) {
       self.formid = formid
       self.formContent = formContent
       self.images = images
    }
    
    init() {
        
    }
    
    enum CodingKeys : String, CodingKey {
        case formid = "Id"
        case formContent = "Content"
        case images = "Images"
    }
}
