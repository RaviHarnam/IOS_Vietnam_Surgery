//
//  FormHelper.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

public class FormHelper {
    public static func getFormTemplateFields(json: String) -> [[String:String]]? {
//        let decoder = JSONDecoder()
//        var fieldsDictionary : [[String:String]] = [[:]]
        var json = json
//        if json.starts(with: "[") && json.last == "]" {
////            json.removeFirst()
////            json.removeLast()
//            //json = /* "\"" + "fields" + "\"" + ":" + */ "\"" + json + "\""
//        }
        //print(json)
        let data = json.data(using: .utf8)!
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: String]]
        return dictionary
        print(dictionary)
        
//        let fields = json.split(separator: ",")
//        for field in fields {
//            print(field)
//            var values = field.split(separator: ":")
//            var tmpArray : [String] = []
//            for value in values {
//                var value = value
//                if value.starts(with: "\"") && value.last == "\"" {
//                    value.removeFirst()
//                    value.removeLast()
//                }
//                tmpArray.append(String(value))
//            }
//            fieldsDictionary.append([tmpArray.first!:tmpArray.last!])
//            tmpArray = []
//        }
//
//        print(fieldsDictionary)
    }
}
