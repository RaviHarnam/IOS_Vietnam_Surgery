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
    
    public var isChoiceField : Bool {
        get { return fieldType.lowercased() == "choice" }
    }
    
    public var delegateCallback : CallbackProtocol?
    
    public var field : FormChoiceField?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if choiceFieldAnswers.isEmpty && isChoiceField {
            choiceFieldAnswers.append("")
            choiceFieldAnswers.append("")
        }
        
        setupForm()
        setupAppBar()
        setupTableview()
    }
    
    func setupForm() {
        fieldNameTextField.text = field?.name
        fieldNameTextField.placeholder = NSLocalizedString("FieldName", comment: "")
        
        fieldRequiredSegControl.removeAllSegments()
        fieldRequiredSegControl.insertSegment(withTitle: NSLocalizedString("Yes", comment: ""), at: 0, animated: true)
        fieldRequiredSegControl.insertSegment(withTitle: NSLocalizedString("No", comment: ""), at: 1, animated: true)
        fieldRequiredSegControl.selectedSegmentIndex = 1
        
    }
    
    func setupAppBar() {
        var barButtonItems : [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveClicked)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    func setupTableview() {
        self.fieldAnswersTableView.dataSource = self
        self.fieldAnswersTableView.register(UINib(nibName: "SimpleTextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTextFieldTableViewCell")
    }
    
    @objc func saveClicked() {
        field!.name = fieldNameTextField.text
        field!.required = fieldRequiredSegControl.selectedSegmentIndex == 0 ? "True" : "False"
        field!.options = isChoiceField ? choiceFieldAnswers : nil
        
        delegateCallback?.setValue(data: field!)
        navigationController?.popViewController(animated: true)
        //navigationController?.popViewController(animated: true)
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.fieldAnswersTableView.frame
            //let spacing = CGFloat(self.choiceFieldAnswers.count == 0 ? 2 : self.choiceFieldAnswers.count * 30)
            frame.size.height = self.fieldAnswersTableView.contentSize.height //+ spacing
            self.fieldAnswersTableView.frame = frame
        }
    }
    
    @objc func addAnswerClicked() {
        choiceFieldAnswers.append("")
        DispatchQueue.main.async {
             self.fieldAnswersTableView.reloadData()
        }
    }
    
    @objc func answerChanged(_ textField: UITextField) {
        choiceFieldAnswers[textField.tag] = textField.text!
    }
}

extension FormTemplateEditFieldViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return fieldType.lowercased() == "choicefield" ? choiceFieldAnswers.count : 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        return view
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "SimpleTextFieldTableViewCell") as! SimpleTextFieldTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextFieldTableViewCell") as! SimpleTextFieldTableViewCell
        cell.textField.placeholder = NSLocalizedString("Answer", comment: "")
        cell.textField.tag = indexPath.section
        cell.textField.addTarget(self, action: #selector(answerChanged(_:)), for: .editingChanged)
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
