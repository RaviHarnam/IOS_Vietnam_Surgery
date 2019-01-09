//
//  FormHelper.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class FormHelper {
    public static func getFormTemplateFromJson(json: String) -> FormTemplate? {
        //var json = json
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let formTemplate = try? decoder.decode(FormTemplate.self, from: data)
        
        return formTemplate
    }
    
    public static func getJsonFromFormTemplate(template: FormTemplate) -> String? {
        let encoder = JSONEncoder()
        let json = try! encoder.encode(template)
        return String(data: json, encoding: .utf8)
    }
    
    public static func getUIControlsFromSection(section: FormSection) -> [(String,BaseRow)]? {
        var controls : [(String,BaseRow)] = []
        guard let fields = section.fields else { return nil }
        for field in fields {
            let name = field.name!
            switch field.type!.lowercased() {
                case "string":
                    controls.append((name,TextRow(tag: name)))
                    break
                case "int":
                    controls.append((name,IntRow(tag: name)))
                    break
                case "datetime":
                    controls.append((name,DateTimeRow(tag: name)))
                    break
                case "choice":
                    controls.append((name,PushRow<String>(tag: name)))
                    break
                default:
                    break
            }
        }
        return controls
    }
    
    public static func getUIControlsFromFormSection(section: FormSection) -> [FormChoiceField]? {
        var controls : [FormChoiceField] = []
        guard let fields = section.fields else { return nil }
        for field in fields {
            //let name = field.name!
            controls.append(field as! FormChoiceField)
            //switch field.type!.lowercased() {
//            case "string":
//                //controls.append(createTextField(title: name))
//                break
//            default:
//                break
            }
    //}
        return controls
    }
    
    public static func validateFieldsInSection(section: FormSection) -> Bool {
        if let fields = section.fields {
            guard fields.count > 0 else { return false }
            for field in fields {
                guard let name = field.name else { return false }
                guard let type = field.type else { return false }
                
                guard !name.isEmpty else { return false }
                guard !type.isEmpty else { return false }
                
                //guard type.lowercased() != "choice" || type.lowercased() == "choice" && field is FormChoiceField else { return false }
                
                if type.lowercased() == "choice" {
                    guard let options = field.options else { return false }
                    guard options.count > 0 else { return false }
                }
            }
            return true
        }
        return false
    }
    
    public static func validateSectionsInForm(sections: [FormSection]) -> Bool {
        var isValid = true
        for section in sections {
            isValid = (!validateFieldsInSection(section: section) ? false : isValid)
        }
        return isValid
    }
    
    public static func setEurekaRowStylingProperties() {
//        TextRow.defaultCellSetup = { cell, row in
//            cell.preservesSuperviewLayoutMargins = false
//            cell.layoutMargins.left = 16
//            cell.contentView.preservesSuperviewLayoutMargins = false
//            cell.contentView.layoutMargins.left = 16
//            //cell.contentView.layoutMargins.right = 16
//        }
//        TextRow.defaultCellUpdate = { cell,row in
//            cell.preservesSuperviewLayoutMargins = false
//            cell.layoutMargins.left = 16
//            cell.contentView.preservesSuperviewLayoutMargins = false
//            cell.contentView.layoutMargins.left = 16
//
//        }
    }
    
    public static func getFormContentDicFromArr(content: [FormContentKeyValuePair]) -> [String:String] {
        var dic : [String:String] = [:]
        for kvp in content {
            dic[kvp.name!] = kvp.value
        }
        return dic
    }
}
