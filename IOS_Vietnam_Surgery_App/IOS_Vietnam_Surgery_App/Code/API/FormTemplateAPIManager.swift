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
    
    public static func getFormTemplates() -> DataRequest {
        let url = super.apiBaseUrl + self.formPrefix
        return Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
    }
    
    public static func createFormTemplate(form: FormPostPutModel) -> DataRequest {
        let url = super.apiBaseUrl + self.formPrefix + "/"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        if let authenticationtoken = AppDelegate.authenticationToken {
            request.addValue("Bearer " + authenticationtoken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(form)
        request.httpBody = data
        
        return Alamofire.request(request)
    }
    
    public static func editFormTemplate(_ id: Int , form: FormPostPutModel) -> DataRequest {
        let url = super.apiBaseUrl + self.formPrefix + "/" + String(id)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.put.rawValue
        if let authenticationtoken = AppDelegate.authenticationToken {
            request.addValue("Bearer " + authenticationtoken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(form)
        request.httpBody = data
        
        return Alamofire.request(request)
    }
}
