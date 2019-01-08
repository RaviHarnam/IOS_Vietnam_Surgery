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
    //#if DEBUG
    //   public static let apiBaseUrl : String = "https:/192.168.178.2:44302/"
    //#else
       public static let apiBaseUrl : String = "https://vietnamcloudapi.azurewebsites.net/"
    //#endif
    
    public func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
