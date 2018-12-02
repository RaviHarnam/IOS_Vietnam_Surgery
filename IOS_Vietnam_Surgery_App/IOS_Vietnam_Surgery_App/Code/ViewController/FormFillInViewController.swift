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

public class FormFillInViewController : Eureka.FormViewController {
    
    @IBOutlet weak var formView: UIStackView!
    
    public var formData: Form? {
        didSet {
            setupForm()
        }
    }
    
    public var formUIControls : [FormChoiceField]? = [] {
        didSet {
            initializeFormFields()
        }
    }
    
    public var formSection : FormSection? {
        get {
            return formSections[formFillInStep]
        }
    }
    
    public var formSections : [FormSection] = []
    
    public var formContent : [String:String] = [:]
    
    public var formFillInStep = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view
        self.tableView.contentInset.left = 16
        self.tableView.contentInset.right = 16
        //self.tableView.layoutMargins.right = 16
        setupAppbar()
    }
    
    func setupAppbar() {
        if formFillInStep + 1 <= formSections.count {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: ">", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToNextPage))
        }
    }
    
    @objc func goToNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
        vc.formFillInStep = self.formFillInStep + 1
        vc.formContent = self.formContent
        vc.formData = self.formData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupForm() {
            if let template = self.formData?.formTemplate {
            let template = FormHelper.getFormTemplateFromJson(json: template)
            guard let sections = template?.sections else { return }
            formSections = sections
            guard FormHelper.validateFieldsInSection(section: formSection!) else { return }
            //formUIControls = FormHelper.getUIControlsFromSection(section: formSection!)
            formUIControls = FormHelper.getUIControlsFromFormSection(section: formSection!) as! [FormChoiceField]
        }
    }
    
    func initializeFormFields() {
        let section = Section()
        
        for field in formUIControls! {
            switch field.type!.lowercased() {
            case "string":
                    section.append(TextRow() {
                        $0.title = field.name
                        $0.onChange {[unowned self] row in
                            if let fieldValue = row.value {
                                self.formContent[field.name!] = fieldValue
                            }
                        }
                    })
                break
            case "choice":
                section.append(PushRow<String>() {
                    $0.title = field.name
                    $0.options = field.options!
                    $0.onChange {[unowned self] row in
                        if let fieldValue = row.value {
                            self.formContent[field.name!] = fieldValue
                        }
                    }
                })
                break
            default:
                break
            }
        }
        self.form.append(section)
    }
}
