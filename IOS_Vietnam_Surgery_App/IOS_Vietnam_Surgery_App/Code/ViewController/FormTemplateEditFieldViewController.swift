//
//  FormTemplateEditFieldViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/30/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormTemplateEditFieldViewController : UIViewController {
    
    @IBOutlet weak var fieldNameTextField: UITextField!
    
    @IBOutlet weak var fieldRequiredSegControl: UISegmentedControl!
    
    @IBOutlet weak var fieldAnswersTableView: UITableView!
    
    public var choiceFieldAnswers : [String] {
        get { return field?.options ?? [] }
        set { field?.options = newValue }
    }
    
    public var fieldType : String {
        get { return field!.type! }
    }
    public var delegateCallback : CallbackProtocol?
    
    public var field : FormChoiceField?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        setupAppBar()
    }
    
    func setupForm() {
        fieldNameTextField.text = field?.name
        fieldNameTextField.placeholder = NSLocalizedString("FieldName", comment: "")
        
        fieldRequiredSegControl.removeAllSegments()
        fieldRequiredSegControl.insertSegment(withTitle: NSLocalizedString("Yes", comment: ""), at: 0, animated: true)
        fieldRequiredSegControl.insertSegment(withTitle: NSLocalizedString("No", comment: ""), at: 1, animated: true)
        
    }
    
    func setupAppBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked))
    }
    
    @objc func saveClicked() {
        delegateCallback?.setValue(data: field)
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.fieldAnswersTableView.frame
            frame.size.height = self.fieldAnswersTableView.contentSize.height
            self.fieldAnswersTableView.frame = frame
        }
    }
    
    @objc func addAnswerClicked() {
        choiceFieldAnswers.append("")
        DispatchQueue.main.async {
             self.fieldAnswersTableView.reloadData()
        }
    }
}

extension FormTemplateEditFieldViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldType.lowercased() == "choicefield" ? choiceFieldAnswers.count + (choiceFieldAnswers.isEmpty ? 2 : 0) : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SimpleTextFieldTableViewCell") as! SimpleTextFieldTableViewCell
        cell.textField.placeholder = NSLocalizedString("Answer", comment: "")
        return cell
    }
}

extension FormTemplateEditFieldViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = NSLocalizedString("AddAnswer", comment: "")
        label.textColor = ColorHelper.lightBlueLinkColor()
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAnswerClicked)))
        return label
    }
}
