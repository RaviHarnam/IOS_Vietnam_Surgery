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
                guard let required = field.required else { return false }
                
                guard !name.isEmpty else { return false }
                guard !type.isEmpty else { return false }
                guard !required.isEmpty else { return false }
                
                if type.lowercased() == "choice" {
                    guard let options = field.options else { return false }
                    guard options.count > 0 else { return false }
                }
            }
            return true
        }
        return false
    }
    
    public static func validateContainsFieldsInForm(sections: [FormSection]) -> Bool {
        let checkDictionary : NSMutableDictionary = [:]
        checkDictionary[NSLocalizedString("Name", comment: "")] = false
        checkDictionary[NSLocalizedString("District", comment: "")] = false
        checkDictionary[NSLocalizedString("Birthyear", comment: "")] = false
        
        for section in sections {
            if let fields = section.fields {
                for field in fields {
                    for checkField in checkDictionary {
                        if field.name == checkField.key as? String && field.required?.lowercased() == "true" {
                            checkDictionary[checkField.key] = true //print(checkDictionary.updateValue(true, forKey: checkField))
                        }
                    }
                }
            }
        }
        
        return checkDictionary.allSatisfy({
            $0.value as! Bool // == true
        })
    }
    
    public static func validateSectionsInForm(sections: [FormSection]) -> Bool {
        var isValid = true
        for section in sections {
            isValid = (!validateFieldsInSection(section: section) ? false : isValid)
        }
        if isValid {
            isValid = validateContainsFieldsInForm(sections: sections)
        }
        return isValid
    }
    
    public static func getFormContentDicFromArr(content: [FormContentKeyValuePair]) -> [String:String] {
        var dic : [String:String] = [:]
        for kvp in content {
            dic[kvp.name!] = kvp.value
        }
        return dic
    }
    
    public static func decodeImageToUIImage(images: [[UInt8]]) -> [UIImage] {
        var imageArr : [UIImage] = []
        for img in images {
            let data = Data(img)
            imageArr.append(UIImage.init(data: data)!)
        }
        return imageArr
    }
    
    public static func getLocalStorageFileName(_ form: Form) -> String {
        let nameValue = form.formContent?.first(where: {  $0.name?.lowercased() == "name" })!.value
        let districtValue = form.formContent?.first(where: {$0.name?.lowercased() == "district"})!.value
        let birthYearValue = form.formContent?.first(where:{$0.name?.lowercased() == "birthyear"})!.value
        return getLocalStorageFileName(templateName: form.name!, name: nameValue!, district: districtValue!, birthyear: birthYearValue!)
    }
    
    public static func getLocalStorageFileName(_ formContent: FormContent) -> String {
        let nameValue = formContent.formContent?.first(where: {  $0.name?.lowercased() == "name" })!.value
        let districtValue = formContent.formContent?.first(where: {$0.name?.lowercased() == "district"})!.value
        let birthYearValue = formContent.formContent?.first(where:{$0.name?.lowercased() == "birthyear"})!.value
        return getLocalStorageFileName(templateName: formContent.formTemplateName!, name: nameValue!, district: districtValue!, birthyear: birthYearValue!)
    }
    
    private static func getLocalStorageFileName(templateName: String, name: String, district: String, birthyear: String) -> String {
        return templateName + "_" + name + "_" + district + "_" + birthyear + ".json"
    }
}
