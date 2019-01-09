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
    
    //private let fieldTypes = ["TextField", "NumberField", "ChoiceField"]
    private var fieldTypesDic : [String:String] = [:]
    private var currentEditingField : Int?
    private var currentFieldTypeSelected : String? = NSLocalizedString("String", comment: "")
    public var dataChanged : Bool = false
    public var sectionSaveDelegate : CallbackProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sectionTopLabel.text = section?.name
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
    
    @objc func saveClicked() {
        var dic : [Int:FormSection] = [:]
        dic[sectionNumber!] = self.section
        sectionSaveDelegate?.setValue(data: dic)
        navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        self.sectionFieldsTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.sectionFieldsTableView.register(UINib(nibName: "FormAddFieldFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FormAddFieldFooterView")
        self.sectionFieldsTableView.dataSource = self
        self.sectionFieldsTableView.delegate = self
    }
    
    func setupAppBar() {
        var barButtonItems : [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func addFieldClicked(_ sender: UITapGestureRecognizer) {
        //Add field screen
        //self.currentEditingField = sender.view!.tag
        //let field = self.section?.fields?[currentEditingField!]
        self.currentEditingField = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditFieldViewController") as! FormTemplateEditFieldViewController
        //vc.fieldType = field?.type
        let field = FormChoiceField()
        let kvp = fieldTypesDic.first(where: { $0.value == currentFieldTypeSelected })
        field.type = kvp!.key
        vc.delegateCallback = self
        vc.field = field
        //vc.field = FormChoiceField()
        
        //if field?.type?.lowercased() == "choicefield" {
        //    vc.choiceFieldAnswers = field?.options ?? []
        //}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fieldTypeValueChanged(segment: UISegmentedControl) {
        self.currentFieldTypeSelected = segment.titleForSegment(at: segment.selectedSegmentIndex)
    }
}

extension FormTemplateEditSectionViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.fields?.count ?? 0
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        if let fields = self.section!.fields {
            cell.leftLabel.text = fields[indexPath.row].name
            
            cell.rightLabel.textColor = ColorHelper.lightGrayTextColor()
            cell.rightLabel.text = fields[indexPath.row].type
        }
        return cell
    }
}

extension FormTemplateEditSectionViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//
//        let segControl = UISegmentedControl(items: self.fieldTypes)
//        segControl.selectedSegmentIndex = 0
//
//        let label = UILabel()
//        label.text = NSLocalizedString("AddField", comment: "")
//        label.textColor = ColorHelper.lightBlueLinkColor()
//        label.layoutMargins.left = 40
//
//        footerView.addSubview(segControl)
//        footerView.addSubview(label)
//        return footerView
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
}

extension FormTemplateEditSectionViewController : CallbackProtocol {
    public func setValue(data: Any) {
        if let fieldId = currentEditingField {
            let newField = data as! FormChoiceField
            self.section!.fields![fieldId] = newField
            self.dataChanged = true
        }
        else {
            let newField = data as! FormChoiceField
            self.section!.fields?.append(newField)
            self.dataChanged = true
        }
    }
}
