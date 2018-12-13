//
//  UserAPIManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 13/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import Alamofire

public class UserAPIManager : BaseAPIManager {
    public static let formPrefix : String = "api/Account"
    
    public static func GetFormTemplates() -> DataRequest {
        let url = super.apiBaseUrl + self.formPrefix
        return Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
    }
}
