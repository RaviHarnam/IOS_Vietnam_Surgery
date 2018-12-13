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
    
    public static let registerPrefix = "api/Account"
    public static let loginPrefix = "/token"
    
    public static func Register(register: Register) -> DataRequest {
        let url = super.apiBaseUrl + self.registerPrefix
        
        let encoder = JSONEncoder()
        
        let jsondata = try? encoder.encode(register)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        
        return Alamofire.request(request)
    }
    
    public static func Login(login: Login) -> DataRequest {
        
        let url = super.apiBaseUrl + self.loginPrefix
        
        let encoder = JSONEncoder()
        
        let jsondata = try? encoder.encode(login)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsondata
        
        return Alamofire.request(request)
    }
}
