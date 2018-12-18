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
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        formExplanationText.text = NSLocalizedString("", comment: "")
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
        
        if let template = self.form?.formTemplate {
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
    
    
}

extension FormTemplateEditViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = formSections[section].name
        label.textColor = UIColor.black
        label.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        label.font = label.font.withSize(34)
        
        return label
    }
}
