//
//  FormManager.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 19/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class FormManager {
    
    
    static func getAllFormContent(token: String, role: String,callBack: @escaping ([FormTemplatePlusContent]?) -> ()) {
        
        var formtemplatepluscontents : [FormTemplatePlusContent] = []
        FormContentAPIManager.getFormDataFromDB(token: token, role: role).responseJSON(completionHandler: {
            (response) in
            guard let jsonData = response.data else { return }
            //print("Get all accounts: ", response)
            
            let decoder = JSONDecoder()
            let decodedUserObject = try? decoder.decode([FormTemplatePlusContent].self, from: jsonData)
            
            if let formtemplatepluscontentArray = decodedUserObject {
                for formteplatepluscontent in formtemplatepluscontentArray {
                    formtemplatepluscontents.append(formteplatepluscontent)
             
                }
                callBack(formtemplatepluscontents)
                
            }
            else{
                callBack(nil)
            }
        })
    }
}
