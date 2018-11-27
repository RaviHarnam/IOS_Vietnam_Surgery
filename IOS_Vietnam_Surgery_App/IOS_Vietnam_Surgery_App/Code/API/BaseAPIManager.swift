//
//  BaseAPIManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import Alamofire

public class BaseAPIManager {
    public static let apiBaseUrl : String = "https://cloudapicustom.azurewebsites.net/"
    
    public func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
