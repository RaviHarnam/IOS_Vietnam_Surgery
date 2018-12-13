//
//  FormTemplateEditViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/13/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class FormTemplateEditViewController : UIViewController {
    
    public var form : Form? {
        didSet {
                setupForm()
            }
        }
    
    public var formSections : [FormSection] = []
    
    public var formUIControls : [BaseRow] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        if form == nil {
            title = NSLocalizedString("FormTemplatCreateViewControllerTitle", comment: "")
        }
        else {
            title = NSLocalizedString("FormTemplateEditViewControllerTitle", comment: "")
        }
    }
    
    func setupForm() {
        if let template = self.form?.formTemplate {
            let template = FormHelper.getFormTemplateFromJson(json: template)
            guard let sections = template?.sections else { return }
            self.formSections = sections
//            guard FormHelper.validateFieldsInSection(section: formSections) else { return }
            //formUIControls = FormHelper.getUIControlsFromSection(section: formSection!)
//            formUIControls = FormHelper.getUIControlsFromFormSection(section: formSection!)
        }
    }
}
