//
//  CheckInternetHelper.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 10/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class AlertHelper {
    
    public static func NoInternetAlert(_ okCallback: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("NoInternet", comment: ""), message: NSLocalizedString("NoInternetMessage" , comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) in
            if let okCallback = okCallback {
                okCallback()
            }
        }))
        
        return alert
    }
}


