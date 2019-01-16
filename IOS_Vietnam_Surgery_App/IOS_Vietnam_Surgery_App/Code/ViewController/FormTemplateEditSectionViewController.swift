//
//  FormTemplateSectionEditViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormTemplateEditSectionViewController : UIViewController {
    
    @IBOutlet weak var sectionFieldsTableView: UITableView!
    @IBOutlet weak var sectionTopLabel: UILabel!
    
    @IBOutlet weak var sectionNameTextField: UITextField!
    public var section : FormSection?
    public var sectionNumber : Int?
    public var form : Form?
    
    //private let fieldTypes = ["TextField", "NumberField", "ChoiceField"]
    private var fieldTypesDic : [String:String] = [:]
    private var currentEditingField : Int?
    private var currentFieldTypeSelected : String? = NSLocalizedString("String", comment: "")
    public var dataChanged : Bool = false
    public var sectionSaveDelegate : CallbackProtocol?
    public var isEditingForm : Bool?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
        
        self.sectionTopLabel.text = section?.name
        self.sectionNameTextField.text = section?.name?.isEmpty ?? true ? "" : section?.name
        self.sectionNameTextField.placeholder = section?.name?.isEmpty ?? true ? NSLocalizedString("SectionNamePlaceholder", comment: "") : section?.name
        self.sectionNameTextField.addTarget(self, action: #selector(sectionNameChanged), for: .editingChanged)
        self.fieldTypesDic["String"] = NSLocalizedString("String", comment: "")
        self.fieldTypesDic["Number"] = NSLocalizedString("Number", comment: "")
        self.fieldTypesDic["Choice"] = NSLocalizedString("Choice", comment: "")
        
        setupTableView()
        setupAppBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.sectionFieldsTableView.reloadData()
                self.resizeTableView()
            }
            dataChanged = false
        }
    }
    
    func updateTitle() {
        if isEditingForm == false {
            title = NSString.localizedStringWithFormat(NSLocalizedString("FormXSectionY", comment: "") as NSString, NSLocalizedString("Create", comment: ""), form?.name ?? "", section?.name ?? "") as String
        }
        else {
            title = NSString.localizedStringWithFormat(NSLocalizedString("FormXSectionY", comment: "") as NSString, NSLocalizedString("Edit", comment: ""), form?.name ?? "", section?.name ?? "") as String
        }
    }
    
    func resizeTableView() {
        DispatchQueue.main.async {
            var frame = self.sectionFieldsTableView.frame
            frame.size.height = self.sectionFieldsTableView.contentSize.height
            self.sectionFieldsTableView.frame = frame
        }
    }
    
    public override func viewWillLayoutSubviews() {
        if !dataChanged {
            DispatchQueue.main.async {
                var frame = self.sectionFieldsTableView.frame
                frame.size.height = self.sectionFieldsTableView.contentSize.height
                self.sectionFieldsTableView.frame = frame
            }
        }
    }
    
    func setupTableView() {
        self.sectionFieldsTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.sectionFieldsTableView.register(UINib(nibName: "FormAddFieldFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FormAddFieldFooterView")
        self.sectionFieldsTableView.dataSource = self
        self.sectionFieldsTableView.delegate = self
        DispatchQueue.main.async {
            self.sectionFieldsTableView.reloadData()
        }
    }
    
    func setupAppBar() {
        var barButtonItems : [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked)))
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Delete"), style: .plain, target: self, action: #selector(deleteClicked)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    func validateSection() -> Bool {
        guard let sectionName = self.sectionNameTextField.text else { return false }
        guard !sectionName.isEmpty else { return false }
        
        return true
    }
    
    @objc func sectionNameChanged(sectionNameTextField: UITextField) {
        sectionNameTextField.layer.borderColor = nil
        sectionNameTextField.layer.borderWidth = 0
        self.section?.name = sectionNameTextField.text
        self.sectionTopLabel.text = sectionNameTextField.text
        updateTitle()
    }
    
    @objc func saveClicked() {
        if !validateSection() {
            sectionNameTextField.layer.borderColor = UIColor.red.cgColor
            sectionNameTextField.layer.borderWidth = 1
            return
        }
        var dic : [Int:FormSection] = [:]
        dic[sectionNumber!] = self.section
        sectionSaveDelegate?.setValue(data: dic)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteClicked() {
        var dictionary : [Int:FormSection?] = [:]
        dictionary[sectionNumber!] = nil as FormSection?
        sectionSaveDelegate?.setValue(data: dictionary)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addFieldClicked(_ sender: UITapGestureRecognizer) {
        self.currentEditingField = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditFieldViewController") as! FormTemplateEditFieldViewController
        //vc.fieldType = field?.type
        let field = FormChoiceField()
        let kvp = fieldTypesDic.first(where: { $0.value == currentFieldTypeSelected })
        field.type = kvp!.key
        vc.delegateCallback = self
        vc.field = field
        vc.section = section
        vc.isEditingForm = isEditingForm
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fieldTypeValueChanged(segment: UISegmentedControl) {
        self.currentFieldTypeSelected = segment.titleForSegment(at: segment.selectedSegmentIndex)
    }
}

extension FormTemplateEditSectionViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.fields?.count == 0 ? 1 : self.section?.fields?.count ?? 0
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        
        if let fields = self.section!.fields {
            if fields.count == 0 {
                cell.leftLabel.text = NSLocalizedString("NoFieldsInSectionMessage", comment: "")
                cell.rightLabel.text = ""
            }
            else {
                cell.leftLabel.text = fields[indexPath.row].name
            
                cell.rightLabel.textColor = ColorHelper.lightGrayTextColor()
                cell.rightLabel.text = fields[indexPath.row].type
            }
        }
        else {
            cell.leftLabel.text = NSLocalizedString("NoFieldsInSectionMessage", comment: "")
        }
        return cell
    }
}

extension FormTemplateEditSectionViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FormAddFieldFooterView") as! FormAddFieldFooterView
        let bgView = UIView()
        bgView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        footerView.backgroundView = bgView
        
        footerView.addFieldLabel.isUserInteractionEnabled = true
        footerView.addFieldLabel.text = NSLocalizedString("AddField", comment: "")
        footerView.addFieldLabel.textColor = ColorHelper.lightBlueLinkColor()
        footerView.addFieldLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addFieldClicked(_: ))))
        
        footerView.fieldTypeSegControl.removeAllSegments()
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypesDic["String"], at: 0, animated: true)
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypesDic["Number"], at: 1, animated: true)
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypesDic["Choice"], at: 2, animated: true)
        footerView.fieldTypeSegControl.selectedSegmentIndex = 0
        footerView.fieldTypeSegControl.addTarget(self, action: #selector(fieldTypeValueChanged), for: .valueChanged)
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentEditingField = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditFieldViewController") as! FormTemplateEditFieldViewController
        vc.field = self.section?.fields![indexPath.row]
        vc.section = self.section
        vc.form = self.form
        vc.delegateCallback = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FormTemplateEditSectionViewController : CallbackProtocol {
    public func setValue(data: Any) {
        if let fieldId = currentEditingField {
            if let newField = data as? FormChoiceField {
                self.section!.fields![fieldId] = newField
            }
            else {
                self.section!.fields?.remove(at: fieldId)
            }           
        }
        else {
            let newField = data as! FormChoiceField
            self.section!.fields?.append(newField)
        }
        self.dataChanged = true
    }
}
