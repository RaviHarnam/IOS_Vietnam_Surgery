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
    
    public var section : FormSection?
    
    private let fieldTypes = ["TextField", "NumberField", "ChoiceField"]
    private var currentEditingField : Int?
    private var currentFieldTypeSelected : Int = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sectionTopLabel.text = section?.name
        
        setupTableView()
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.sectionFieldsTableView.frame
            frame.size.height = self.sectionFieldsTableView.contentSize.height
            self.sectionFieldsTableView.frame = frame
        }
    }
    
    func setupTableView() {
        self.sectionFieldsTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.sectionFieldsTableView.register(UINib(nibName: "FormAddFieldFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FormAddFieldFooterView")
        self.sectionFieldsTableView.dataSource = self
        self.sectionFieldsTableView.delegate = self
    }
    
    @objc func addFieldClicked(_ sender: UITapGestureRecognizer) {
        //Add field screen
        //self.currentEditingField = sender.view!.tag
        //let field = self.section?.fields?[currentEditingField!]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditFieldViewController") as! FormTemplateEditFieldViewController
        //vc.fieldType = field?.type
        let field = FormChoiceField()
        field.type = fieldTypes[currentFieldTypeSelected]
        vc.delegateCallback = self
        //vc.field = FormChoiceField()
        
        //if field?.type?.lowercased() == "choicefield" {
        //    vc.choiceFieldAnswers = field?.options ?? []
        //}
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fieldTypeValueChanged(segment: UISegmentedControl) {
        self.currentFieldTypeSelected = segment.selectedSegmentIndex
    }
}

extension FormTemplateEditSectionViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.section?.fields?.count ?? 0
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
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypes[0], at: 0, animated: true)
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypes[1], at: 1, animated: true)
        footerView.fieldTypeSegControl.insertSegment(withTitle: fieldTypes[2], at: 2, animated: true)
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
            self.section?.fields![fieldId] = newField
            DispatchQueue.main.async {
                self.sectionFieldsTableView.reloadData()
            }
        }
    }
}
