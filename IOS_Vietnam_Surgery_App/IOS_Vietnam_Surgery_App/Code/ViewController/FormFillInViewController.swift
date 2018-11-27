//
//  FormFillInViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormFillInViewController : UIViewController {
    
    public var formTemplate : FormTemplate?
    
    override public func viewDidLoad() {
        if let template = formTemplate?.formTemplate {
            FormHelper.getFormTemplateFields(json: template)
        }
        
    }
}
