//
//  FormFillInViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class FormFillInViewController : FormViewController {
    
    public var formData: Form? {
        didSet {
            setupForm()
        }
    }
    
    public var formUIControls : [String:BaseRow]? = [:] {
        didSet {
            initializeFormFields()
        }
    }
    
    public var formSection : FormSection?
    
    public var formFillInStep = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupForm() {
        if let template = self.formData?.formTemplate {
            let template = FormHelper.getFormTemplateFromJson(json: template)
            guard let sections = template?.sections else { return }
            formSection = sections[formFillInStep]
            guard FormHelper.validateFieldsInSection(section: formSection!) else { return }
            formUIControls = FormHelper.getUIControlsFromSection(section: formSection!)
        }
    }
    
    func initializeFormFields() {
        var section = Section(formSection!.name!)
        
        for field in formUIControls! {
            section.append(field.value)
            section.reverse()
        }
        form.append(section)
        print(formUIControls)
        
    }
}

//extension FormFillInViewController : UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return formUIControls.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let field = formUIControls[indexPath.row]
//
//
//        return cell
//    }
//
//
//}
