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
    
    
    func Register(register: Register)
    {
        let registerUser = register
        
        UserAPIManager.Register(register: registerUser).responseData(completionHandler:{
            (response) in
            
            if let data = response.data{
                let decoder = JSONDecoder()
                let customResponse = try? decoder.decode(customHTTPResponse.self, from: data)
                
                if(customResponse?.succes == true)
                {
                    print("succesfully registred")
                
                }
                else
                {
                    print("not registered")
                  
                }
            }
        })
    }
    
    static func UserLogIn(login: Login)
    {
        let loginUser = login
        
        UserAPIManager.Login(login: loginUser).responseData(completionHandler: {
            (response) in
            
            if let data = response.data{
                let decoder = JSONDecoder()
                let authtenticationResponse = try? decoder.decode(AuthenticationToken.self, from: data)
                print("AuthResponse: ", authtenticationResponse)
                if let authenticationresponse = authtenticationResponse{
                    print(authenticationresponse.authenticationtoken)
                    
                    AppDelegate.authenticationToken = authenticationresponse.authenticationtoken
                    KeychainWrapper.standard.set(authenticationresponse.authenticationtoken, forKey: LoginViewController.tokenkey)
                    
                    print("Succesfully logged in")
                }
                else {
                    print("login failed")
                }
            }
        })
    }

}
