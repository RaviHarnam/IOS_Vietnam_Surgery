//
//  UserManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 12/12/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

public class UserManager {
    
    static func Register(register: Register, callbackUser: @escaping (User?) -> ()) {
        let registerUser = register
        
        UserAPIManager.Register(register: registerUser).responseData(completionHandler: {
            (response) in
            print (response)
            if let data = response.data{
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                
                if(response.response?.statusCode == 200) {
                    callbackUser(user)
                }
                else {
                    callbackUser(nil)
                }
            }
        })
    }
    
    static func UserLogIn(login: Login, callBack: @escaping (Bool) -> ()) {
        let loginUser = login
        UserAPIManager.Login(login: loginUser).responseJSON(completionHandler: {
            (response) in
            if let data = response.data {
                let decoder = JSONDecoder()
                
                if let authresponse = try? decoder.decode(AuthenticationToken.self, from: data) {
                    guard let authtoken = authresponse.authenticationtoken else {
                        callBack(false)
                        return
                    }
                    AppDelegate.authenticationToken = authtoken
                    AppDelegate.userRole = authresponse.role
                    AppDelegate.userName = authresponse.username
                    KeychainWrapper.standard.set(authtoken, forKey: LoginViewController.tokenkey)
                    callBack(true)
                }
                else {
                    callBack(false)
                }
            }
        })
    }
    
    static func getAllUsers(callBack: @escaping ([User]?) -> ()) {
        var users : [User] = []
        UserAPIManager.GetAllUsers(token: AppDelegate.authenticationToken).responseJSON(completionHandler: {
            (response) in
            
            guard let jsonData = response.data else { return }
            let decoder = JSONDecoder()
            let decodedUserObject = try? decoder.decode([User].self, from: jsonData)
            
            if let usersArray = decodedUserObject {
                for user in usersArray {
                    users.append(user)
                }
                callBack(users) 
            }
            else{
                callBack(nil)
            }
        })
    }
}
