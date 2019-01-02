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
    
    public static let accountPrefix = "api/Account"
    public static let loginPrefix = "token"
    public static var userobject : User?
    
    public static func Register(register: Register) -> DataRequest {
        let url = super.apiBaseUrl + self.accountPrefix
        
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
        
        print(url)
        
        let encoder = JSONEncoder()
        
        let jsondata = try? encoder.encode(login)

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters: [String: String] = [

            "username" : login.username!,
            "password" : login.password!,
            "grant_type" : "password"
        ]
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        print(jsondata)
//        request.httpBody = jsondata
//        print("body: ", request.httpBody)
        
        return Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
    }
    
    public static func GetAllUsers(token: String?) -> DataRequest {
        
        let url = super.apiBaseUrl + self.accountPrefix
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
