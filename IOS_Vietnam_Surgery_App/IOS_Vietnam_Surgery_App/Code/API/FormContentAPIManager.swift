//
//  FormContentAPIManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 08/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import Alamofire

public class FormContentAPIManager : BaseAPIManager {
    public static let formPrefix : String = "api/FormContent" 
    
    public static func syncFormContent(form: FormContent) -> DataRequest {
        
        let url = super.apiBaseUrl + self.formPrefix
        
        let encoder = JSONEncoder()
        let jsondata = try? encoder.encode(form)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        print(String(data: jsondata!, encoding: .utf8))
        request.httpBody = jsondata
        request.setValue("Bearer " + AppDelegate.authenticationToken!, forHTTPHeaderField: "Authorization")
        
        return Alamofire.request(request)
            //.responseJSON(completionHandler: {(response) in guard let jsonData = response.data else {return}})
        
       // return Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
    }
    
    public static func getFormDataFromDB(token: String?, role: String) -> DataRequest {
        
        let url = super.apiBaseUrl + self.formPrefix
        
        var parameters : [String:String] = [
            
            "token_type" : "bearer"
        ]
        var header: [String:String] = [:]
        if let authenticationtoken = token {
            
            header = ["Authorization": "Bearer " + authenticationtoken]
        }
        
        return Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: {(response) in guard let jsonData = response.data else {return}})
       
    }
}
