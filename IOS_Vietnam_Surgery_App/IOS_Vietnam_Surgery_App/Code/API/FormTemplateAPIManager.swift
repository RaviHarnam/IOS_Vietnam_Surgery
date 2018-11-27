//
//  FormTemplateAPIManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import Alamofire

public class FormTemplateAPIManager : BaseAPIManager {
    public static let formPrefix : String = "api/formulieren"
    
    public static func GetFormTemplates() -> DataRequest {
        let url = super.apiBaseUrl + self.formPrefix
        return Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
    }
    
    
}
