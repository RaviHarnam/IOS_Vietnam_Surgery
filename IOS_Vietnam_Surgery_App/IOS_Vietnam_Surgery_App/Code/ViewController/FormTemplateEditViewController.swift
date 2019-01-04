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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        formExplanationText.text = NSLocalizedString("FormTemplateEditExplanationText", comment: "")
        formNameTextField.placeholder = NSLocalizedString("", comment: "")
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.formTableView.frame
            frame.size.height = self.formTableView.contentSize.height
            self.formTableView.frame = frame
        }
    }
    
    func setupForm() {
        if form == nil {
            title = NSLocalizedString("FormTemplatCreateViewControllerTitle", comment: "")
        }
        else {
            title = NSLocalizedString("FormTemplateEditViewControllerTitle", comment: "")
        }
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
    
    func setupTableView() {
        self.formTableView.dataSource = self
        self.formTableView.delegate = self
        self.formTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.formTableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
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
        cell.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        
        let section = formSections[indexPath.section]
        if let fields = section.fields {
            cell.leftLabel.text = fields[indexPath.row].name
            cell.rightLabel.text = NSLocalizedString(fields[indexPath.row].type!, comment: "")

//            guard FormHelper.validateFieldsInSection(section: formSections) else { return }
            //formUIControls = FormHelper.getUIControlsFromSection(section: formSection!)
//           formUIControls = FormHelper.getUIControlsFromFormSection(section: formSection!)
        }
        
        return cell
    }
    
    @objc func editSectionClicked(sender: UIGestureRecognizer) {
        if let section = sender.view {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditSectionViewController") as! FormTemplateEditSectionViewController
            //vc.formContent = self.formContent
            //vc.formData = self.formData
            //vc.formFillInStep = section.tag
            vc.section = self.formSections[section.tag]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FormTemplateEditViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = formSections[section].name
//        label.textColor = UIColor.black
//        label.backgroundColor = ColorHelper.lightGrayBackgroundColor()
//        label.font = label.font.withSize(34)
//
//
//        return label
        let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! FormPreviewHeaderView
        //let headerview = headView as! FormPreviewHeaderView
//        if headerview.content == nil {
//            let v = UINib(nibName: "FormPreviewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FormPreviewContent
//            headerview.contentView.addSubview(v)
//            v.translatesAutoresizingMaskIntoConstraints = false
//            v.topAnchor.constraint(equalTo: headerview.contentView.topAnchor).isActive = true
//            v.bottomAnchor.constraint(equalTo: headerview.contentView.bottomAnchor).isActive = true
//            v.leadingAnchor.constraint(equalTo: headerview.contentView.leadingAnchor).isActive = true
//            v.trailingAnchor.constraint(equalTo: headerview.contentView.trailingAnchor).isActive = true
//            headerview.content = v
//        }
        
//        headerview.content.label.text = formSections[section].name
//        headerview.content.label.font = headerview.content.label.font.withSize(34)
//        headerview.content.image.image = UIImage(named: "Edit")
//        headerview.content.image.isUserInteractionEnabled = true
//        headerview.content.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editSectionClicked)))
//        headerview.content.image.tag = section
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
