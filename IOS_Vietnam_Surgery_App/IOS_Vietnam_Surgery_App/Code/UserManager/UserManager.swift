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

class UserManager {
    
    // Voor Ravi TODO
    
    // handle login
    
    // add new users as admin
    
    // initialize certain viewcontroller based on rights(Authorization)
    
    // Implemented register
    
    
    func checkIfUserIsAdmin() {
        
    }
    
    static func Register(register: Register, callbackUser: @escaping (User?) -> ()) {
        let registerUser = register
        
        UserAPIManager.Register(register: registerUser).responseData(completionHandler: {
            (response) in
            
            print (response)
            if let data = response.data{
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                
                if(response.response?.statusCode == 200) {
                    print("succesfully registred")
                    callbackUser(user)
                }
                else {
                    print("not registered")
                    callbackUser(nil)
                }
            }
        })
    }
    
    // implemented lpgin
    static func UserLogIn(login: Login, callBack: @escaping (Bool) -> ()) {
       
        let loginUser = login
        
        UserAPIManager.Login(login: loginUser).responseJSON(completionHandler: {
            (response) in
            
            print("response data : ",response)
            if let data = response.data {
                print("Data: ", data)
                let decoder = JSONDecoder()
                //let authenticationresponse = try? decoder.decode(AuthenticationToken.self, from: data)
               // print("AuthResponse: ", authenticationresponse)
                
//                if let authenticationresponse = authenticationresponse {
                   // print(authenticationresponse.authenticationtoken)

                if let authresponse = try? decoder.decode(AuthenticationToken.self, from: data) {
                    guard let authtoken = authresponse.authenticationtoken else {
                        callBack(false)
                        return
                    }
                    //if let authtresponse = authenticationresponse {
                    AppDelegate.authenticationToken = authtoken
                    AppDelegate.userRole = authresponse.role
                    AppDelegate.userName = authresponse.username
                    print("UserRole = ", AppDelegate.userRole)
                    KeychainWrapper.standard.set(authtoken, forKey: LoginViewController.tokenkey)
                        callBack(true)
                        //getAllUsers()
                    }
                    else {
                        //print("Authtoken failed to put in keychain")
                        callBack(false)
                    }
                
                   /// print("Succesfully logged in")
                }
                else {
                    print("login failed")
                
                }
        })
    }
    
    
    static func getAllUsers(callBack: @escaping ([User]?) -> ()) {
        
        var users : [User] = []
        print("Appdelegate.authentifcationToken: ", AppDelegate.authenticationToken)
        UserAPIManager.GetAllUsers(token: AppDelegate.authenticationToken).responseJSON(completionHandler: {
            (response) in
            guard let jsonData = response.data else { return }
            //print("Get all accounts: ", response)
            
            let decoder = JSONDecoder()
            let decodedUserObject = try? decoder.decode([User].self, from: jsonData)
            
            if let usersArray = decodedUserObject {
                for user in usersArray {
                    users.append(user)
                   // print(user.username)
                }
                callBack(users)
               
            }
            else{
                callBack(nil)
            }
        })
    }
}
