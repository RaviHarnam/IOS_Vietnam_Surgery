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
    
    func Register(register: Register) {
        let registerUser = register
        
        UserAPIManager.Register(register: registerUser).responseData(completionHandler: {
            (response) in
            
            if let data = response.data{
                let decoder = JSONDecoder()
                let customResponse = try? decoder.decode(customHTTPResponse.self, from: data)
                
                if(customResponse?.succes == true) {
                    print("succesfully registred")
                }
                else {
                    print("not registered")
                  
                }
            }
        })
    }
    
    // implemented lpgin
    static func UserLogIn(login: Login, callBack: @escaping (Bool) -> ()) {
        let queue = DispatchQueue(label: "label")
        let loginUser = login
        
        UserAPIManager.Login(login: loginUser).responseJSON(completionHandler: {
            (response) in
            
            print("response data : ",response)
            if let data = response.data {
                print("Data: ", data)
                let decoder = JSONDecoder()
                let authenticationresponse = try? decoder.decode(AuthenticationToken.self, from: data)
                print("AuthResponse: ", authenticationresponse)
                
                if let authenticationresponse = authenticationresponse {
                    print(authenticationresponse.authenticationtoken)

                    AppDelegate.authenticationToken = authenticationresponse.authenticationtoken
                    if let authtoken = authenticationresponse.authenticationtoken {
                        print("AuthTokenValue: ", authtoken)
                        KeychainWrapper.standard.set(authtoken, forKey: LoginViewController.tokenkey)
                        callBack(true)
                        
                        getAllUsers()
                    }
                    else {
                        print("AuthTokenValue: ", authenticationresponse.authenticationtoken)
                        print("Authtoken failed to put in keychain")
                        callBack(false)
                    }
                
                    print("Succesfully logged in")
                }
                else {
                    print("login failed")
                   
                }
            }
        })
    }
    
    
    static func getAllUsers() {
        print("Appdelegate.authentifcationToken: ", AppDelegate.authenticationToken)
        UserAPIManager.GetAllUsers(token: AppDelegate.authenticationToken).responseJSON(completionHandler: {
            
            (response) in
            guard let jsonData = response.data else { return }
            print("Get all accounts: ", response)
            
            let decoder = JSONDecoder()
            var decodedUserObject = try? decoder.decode([User].self, from: jsonData)
            
            if let usersArray = decodedUserObject {
                for user in usersArray {
                    print(user.username)
                }
            }
        })
    }
}
