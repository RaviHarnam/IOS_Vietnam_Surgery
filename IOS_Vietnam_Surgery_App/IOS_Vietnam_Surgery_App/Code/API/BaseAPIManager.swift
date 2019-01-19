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
    
    public static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    public static func createActivityIndicatorOnView(view: UIView, yPositionPercentage: CGFloat = 50) -> UIActivityIndicatorView {
        let screenSize = UIScreen.main.bounds
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        bgView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.black
        indicator.center = bgView.center
        
        print("Location: ", indicator.center.debugDescription)
        print("Size: ", indicator.frame.size.debugDescription)
        bgView.addSubview(indicator)
        bgView.center = CGPoint(x: (screenSize.size.width / 2), y: (screenSize.size.height * (yPositionPercentage / 100)))
        
        view.addSubview(bgView)
        return indicator
    }
    
    
}
