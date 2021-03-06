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
    
    @IBOutlet weak var formSectionHeader: UILabel!
    
    @IBOutlet weak var formStep: UILabel!
    
    @IBOutlet weak var requiredExplanationText: UILabel!
    
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
            return formSections[formFillInStep!]
        }
    }
    
    public var formSections : [FormSection] = []
    
    public var formContent : [String:String] {
        get { return FormInputContainer.formContent }
        set { FormInputContainer.formContent = newValue }
    }
    
    //public var formContent : [String:String] = [:]
    
    public var formFillInStep : Int?
    
    public var isPreexisting = false
    
    public var formPreviewCallback : CallbackProtocol?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        _ = self.view
        navigationController?.navigationBar.prefersLargeTitles = true
        updateTitle()
        fillInSavedValues()
        requiredExplanationText.text = NSLocalizedString("RequiredExplanationText", comment: "")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
            self.tableView.topAnchor.constraint(equalTo: self.formSectionHeader.bottomAnchor, constant: 16).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16).isActive = true
        }
        setupAppbar()
        self.formSectionHeader.text = formSection?.name
        self.formStep.text = NSString.localizedStringWithFormat(NSLocalizedString("StepXOutOfY", comment: "") as NSString, formFillInStep! + 1, formSections.count + 2) as String
    }
    
    func fillInSavedValues() {
        if let district = AppDelegate.savedDistrictValue {
            formContent[NSLocalizedString("District", comment: "")] = formContent[NSLocalizedString("District", comment: "")] ?? district
        }
        
        if self.formSections.first(where: { $0.fields!.contains(where: { $0.name == NSLocalizedString("Province", comment: "") }) }) != nil {
            if let province = AppDelegate.savedProvinceValue {
                formContent[NSLocalizedString("Province", comment: "")] = formContent[NSLocalizedString("Province", comment: "")] ?? province
            }
        }
        if self.formSections.first(where: { $0.fields!.contains(where: { $0.name == NSLocalizedString("Village", comment: "") }) }) != nil {
            if let village = AppDelegate.savedVillageValue {
                formContent[NSLocalizedString("Village", comment: "")] = formContent[NSLocalizedString("Village", comment: "")] ?? village
            }
        }
        if self.formSections.first(where: { $0.fields!.contains(where: { $0.name == NSLocalizedString("Commune", comment: "") }) }) != nil {
            if let commune = AppDelegate.savedCommuneValue {
                formContent[NSLocalizedString("Commune", comment: "")] = formContent[NSLocalizedString("Commune", comment: "")] ?? commune
            }
        }
    }
    
    func updateTitle() {
        var newTitle : String = ""
        
        if isPreexisting {
            newTitle += NSLocalizedString("formFillInViewControllerEditTitle", comment: "")
        }
        else {
            newTitle += NSLocalizedString("formFillInViewControllerNewTitle", comment: "")
        }
        
        if let formname = formData?.name {
            newTitle += " - " + formname
        }
        
        if let district = formContent[NSLocalizedString("District", comment: "")] {
            newTitle += " - " + district
        }
        
        if let name = formContent[NSLocalizedString("Name", comment: "")] {
            newTitle += " - " + name
        }
        
        if let birthYear = formContent[NSLocalizedString("Birthyear", comment: "")] {
            newTitle += " - " + birthYear
        }
        
        self.title = newTitle
    }
    
    func setupAppbar() {
        if isPreexisting {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: .plain, target: self, action: #selector(goToPreview))
        }
        else if formFillInStep! + 1 < formSections.count {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToNextPage))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToPictures))
        }
    }
    
    func validateForm() -> Bool {
        let errors = self.form.validate()
        let valid = errors.isEmpty
        if !valid {
            for error in errors {
                self.form.rowBy(tag: error.msg)?.baseCell.textLabel?.textColor = UIColor.red
            }
        }
        return valid
    }
    
    @objc func goToPreview() {
        guard validateForm() else {
            return
        }
        self.formPreviewCallback?.setValue(data: self.formContent)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goToNextPage() {
        guard validateForm() else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
        vc.formFillInStep = self.formFillInStep! + 1
        vc.formContent = self.formContent
        vc.formData = self.formData
        vc.formSections = self.formSections
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToPictures() {
        guard validateForm() else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormPicturesViewController") as! FormPicturesViewController
        self.formData?.formPictures = []
        vc.formFillInStep = self.formFillInStep! + 1
        vc.formContent = self.formContent
        vc.formData = self.formData
        vc.formSections = self.formSections
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupForm() {
        if let template = self.formData?.formTemplate {
            let template = FormHelper.getFormTemplateFromJson(json: template)
            guard let sections = template?.sections else { return }
            formSections = sections
            guard FormHelper.validateFieldsInSection(section: formSection!) else { return }
            
            formUIControls = formSection?.fields  //FormHelper.getUIControlsFromFormSection(section: formSection!)
        }
    }
    
    func initializeFormFields() {
        let section = Section()
        
        for field in formUIControls! {
            switch field.type!.lowercased() {
            case "string":
                    section.append(TextRow() {
                        $0.title = field.name! + (field.required?.lowercased() == "true" ? " *" : "")
                        $0.tag = field.name
                        $0.onChange {[unowned self] row in
                            if let fieldValue = row.value {
                                self.formContent[field.name!] = fieldValue
                                if field.name == NSLocalizedString("Name", comment: "") {
                                    self.updateTitle()
                                }
                                if field.name == NSLocalizedString("District", comment: "") {
                                    self.updateTitle()
                                }
                            }
                        }
                        $0.cell.height = ({ return 50 })
                        $0.validationOptions = .validatesOnDemand
                        if field.required?.lowercased() == "true" { $0.add(rule: RuleRequired(msg: field.name!, id: field.name)) }
                        $0.value = formContent[field.name!] ?? ""
                    })
                break
            case "choice":
                section.append(PushRow<String>() {
                    $0.title = field.name! + (field.required?.lowercased() == "true" ? " *" : "")
                    $0.tag = field.name
                    $0.options = field.options!
                    $0.onChange {[unowned self] row in
                        if let fieldValue = row.value {
                            self.formContent[field.name!] = fieldValue
                        }
                    }
                    $0.validationOptions = .validatesOnDemand
                    $0.cell.height = ({ return 50 })
                    if field.required?.lowercased() == "true" { $0.add(rule: RuleRequired(msg: field.name!, id: field.name)) }
                    $0.value = formContent[field.name!] ?? field.required?.lowercased() == "true" ? $0.options!.first : ""
                    formContent[field.name!] = $0.value
                })
                break
            case "number":
                section.append(IntRow() {
                    $0.title = field.name! + (field.required?.lowercased() == "true" ? " *" : "")
                    $0.tag = field.name
                    $0.onChange {[unowned self] row in
                        if let fieldValue = row.value {
                            self.formContent[field.name!] = String(fieldValue)
                        }
                    }
                    $0.validationOptions = .validatesOnDemand
                    $0.cell.height = ({ return 50 })
                    $0.formatter = nil
                    if field.required?.lowercased() == "true" { $0.add(rule: RuleRequired(msg: field.name!, id: field.name)) }
                    $0.value = formContent[field.name!] != nil ? Int(formContent[field.name!]!) : nil
                })
            default:
                break
            }
        }
        self.form.append(section)
    }
}
