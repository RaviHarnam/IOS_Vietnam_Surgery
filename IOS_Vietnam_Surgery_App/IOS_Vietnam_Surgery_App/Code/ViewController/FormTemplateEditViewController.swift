//
//  FormTemplateEditViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/13/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormTemplateEditViewController : UIViewController {
    
    public var form : Form? {
        didSet {
                setupForm()
            }
        }
    
    public var formSections : [FormSection] = []
    
    @IBOutlet weak var formTableView: UITableView!
    
    @IBOutlet weak var formExplanationText: UILabel!
    
    @IBOutlet weak var formNameTextField: UITextField!
    
    private var headerID = "FormPreviewHeaderView"
    public var sectionNumber : Int?
    
    private var spinner : UIActivityIndicatorView?
    
    public var dataChanged = false
    public var updateFormManagement : CallbackProtocol?
    public var isEditingForm : Bool?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        formExplanationText.text = NSLocalizedString("FormTemplateEditExplanationText", comment: "")
        formNameTextField.placeholder = NSLocalizedString("", comment: "")
        formNameTextField.addTarget(self, action: #selector(formNameChanged), for: .editingChanged)
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        setupAppBar()
        self.extendedLayoutIncludesOpaqueBars = true;
        updateTitle()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.formTableView.reloadData()
            }
            dataChanged = false
        }
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.formTableView.frame
            frame.size.height = self.formTableView.contentSize.height
            self.formTableView.frame = frame
        }
    }
    
    func setupForm() {
        _ = self.view
        if let template = self.form?.formTemplate {
            self.formNameTextField.text = self.form?.name
            let template = FormHelper.getFormTemplateFromJson(json: template)
            guard let sections = template?.sections else { return }
            guard FormHelper.validateSectionsInForm(sections: sections) else { return }
            self.formSections = sections
            DispatchQueue.main.async {
                self.formTableView.reloadData()
            }
        }
    }
    
    func updateTitle() {
        if isEditingForm == false {
            title = NSString.localizedStringWithFormat(NSLocalizedString("FormX", comment: "") as NSString, NSLocalizedString("Create", comment: ""), form?.name ?? "") as String
        }
        else {
            title = NSString.localizedStringWithFormat(NSLocalizedString("FormX", comment: "") as NSString, NSLocalizedString("Edit", comment: ""), form?.name ?? "") as String
        }
    }
    
    func setupTableView() {
        self.formTableView.dataSource = self
        self.formTableView.delegate = self
        self.formTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.formTableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
        
        let footerView = UIView()
        footerView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        self.formTableView.tableFooterView = footerView
        self.formTableView.backgroundView = footerView
    }
    
    func setupAppBar() {
        var barButtonItems : [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked)))
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(addSectionClicked)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func formNameChanged(formNameTextField: UITextField) {
        self.form?.name = formNameTextField.text
        updateTitle()
    }
    
    @objc func addSectionClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditSectionViewController") as! FormTemplateEditSectionViewController
        vc.sectionNumber = formSections.count + 1
        vc.section = FormSection()
        vc.isEditingForm = isEditingForm
        vc.form = self.form
        vc.sectionSaveDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveClicked() {
        guard validateFormTemplate() else {
            showInvalidFormTemplateAlert()
            return
        }
        
        let form = FormPostPutModel()
        let template = FormTemplate()
        template.sections = self.formSections
        
        form.formTemplate = FormHelper.getJsonFromFormTemplate(template: template)
        form.name = self.form?.name
        form.region = self.form?.region ?? form.name
        spinner?.show()
        if self.isEditingForm == false {
            FormTemplateAPIManager.createFormTemplate(form: form).response(completionHandler: {
                (response) in
                self.spinner?.hide()
                if response.response?.statusCode == 200 {
                    let decoder = JSONDecoder()
                    print(String(data: response.data!, encoding: .utf8))

                    let idString = String(data: response.data!, encoding: .utf8)
                    var dic : [Int?:Form] = [:]
                    var returnForm = Form()
                    
                    returnForm.id = Int(idString!)
                    print(returnForm.id)
                    returnForm.name = form.name
                    print(returnForm.name)
                    returnForm.region = form.region
                    print(returnForm.region)
                    returnForm.formTemplate = form.formTemplate
                    print(returnForm.formTemplate)
                    dic[nil] = returnForm
                    self.updateFormManagement?.setValue(data: dic)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else {
            FormTemplateAPIManager.editFormTemplate((self.form?.id)!, form: form).response(completionHandler: {
                (response) in
                self.spinner?.hide()
                print("Statuscode: ", response.response?.statusCode)
                print("Data: ", String(data: response.data!, encoding: .utf8))
                
                if response.response?.statusCode == 200 {
                    var dic : [Int:Form] = [:]
                    let decoder = JSONDecoder()
                    let form = try? decoder.decode(Form.self, from: response.data!)
                    dic[self.sectionNumber!] = form
                    self.updateFormManagement?.setValue(data: dic)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    //TO:DO Add error alert or something. Check 400 to say nothing changed.
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("FormTemplateNothingChanged", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            })
        }
    }
    
    func validateFormTemplate() -> Bool {
        guard self.formSections.count > 0 else { return false }
        guard FormHelper.validateSectionsInForm(sections: self.formSections) else { return false }
        
        return true
    }
    
    func showInvalidFormTemplateAlert() {
        //TO:DO Add error alert
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("InvalidFormTemplate", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension FormTemplateEditViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formSections[section].fields?.count ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return formSections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        cell.contentView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        
        let section = formSections[indexPath.section]
        if let fields = section.fields {
            let field = fields[indexPath.row]
            cell.leftLabel.text = field.name
            cell.rightLabel.text = NSLocalizedString(field.type!, comment: "")
        }
        
        return cell
    }
    
    @objc func editSectionClicked(sender: UIGestureRecognizer) {
        if let section = sender.view {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditSectionViewController") as! FormTemplateEditSectionViewController
            vc.section = self.formSections[section.tag]
            vc.sectionNumber = section.tag
            vc.sectionSaveDelegate = self
            vc.form = self.form
            vc.isEditingForm = isEditingForm
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FormTemplateEditViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! FormPreviewHeaderView
        headerview.label.text = formSections[section].name
        headerview.label.font = headerview.label.font.withSize(34)
        headerview.image.image = UIImage(named: "Edit")
        headerview.image.isUserInteractionEnabled = true
        headerview.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editSectionClicked(sender:))))
        headerview.image.tag = section
        headerview.sectionNumber = section
        headerview.layoutMargins.top = 42
        headerview.layoutMargins.bottom = 42
        let bgView = UIView()
        bgView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        headerview.backgroundView = bgView
        return headerview
    }
}

extension FormTemplateEditViewController : CallbackProtocol {
    public func setValue(data: Any) {
        let sections = data as! Dictionary<Int,FormSection?>
        if let section = sections.first {
            if section.value == nil {
                self.formSections.remove(at: section.key)
            }
            else {
                if section.key >= formSections.count {
                    self.formSections.append(section.value!)
                }
                else {
                    self.formSections[section.key] = section.value!
                }
            }
            self.dataChanged = true
        }
    }
}
