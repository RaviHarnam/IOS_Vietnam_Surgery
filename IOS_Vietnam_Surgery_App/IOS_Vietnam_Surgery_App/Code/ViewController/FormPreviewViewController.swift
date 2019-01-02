//
//  FormPreviewViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/4/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormPreviewViewController : UIViewController {
    
    @IBOutlet weak var formDataTableView: UITableView!
    
    public var formData: Form?
    
    public var formSections : [FormSection] = []
    
    public var formContent : [String:String] = [:]
    
    public var formFillInStep = 0
    
    private var headerID = "FormPreviewHeaderView"
    
    private var editSectionId : Int?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        formDataTableView.register(FormPreviewHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        updateTitle()
        setupTableView()
        setupAppBar()
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.formDataTableView.frame
            frame.size.height = self.formDataTableView.contentSize.height
            self.formDataTableView.frame = frame
        }
    }
    
    func updateTitle() {
        var newTitle : String = ""
        
        newTitle += NSLocalizedString("formPreviewViewControllerNewTitle", comment: "")
        
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
    
    func setupTableView() {
        formDataTableView.dataSource = self
        formDataTableView.delegate = self
        formDataTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
    }
    
    func setupAppBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("SaveAndNext", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(askSaveForm))
    }
    
    @objc func askSaveForm() {
        let alert = UIAlertController.init(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("SaveFormAlertMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
            (action: UIAlertAction) in
            self.saveForm()
            self.navigateToTemplateView()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func saveForm() {
        guard let formData = self.formData else { return }
        for field in formContent {
            formData.formContent?.append(FormContentKeyValuePair(name: field.key, value: field.value))
        }
        
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = (self.formData?.name)! + "_" + formContent["Name"]! + ".json"
        let fileUrl = docDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(self.formData)
            try data.write(to: fileUrl, options: [])
        }
        catch {
            print(error)
        }
    }
    
    func navigateToTemplateView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FormPreviewViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formSections[section].fields?.count ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return formSections.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
//        view.layoutMargins.left = 26
//        view.layoutMargins.top = 42
//        view.layoutMargins.bottom = 42
//        //view.frame = CGRect(x: UIScreen.main.bounds.width , y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//
//        let label = UILabel(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: 80, height: 40))
//        label.textColor = UIColor.black
//        label.text = formSections[section].name
//        label.font = label.font.withSize(34)
//        label.backgroundColor = UIColor(named: "LightGrayBackgroundColor")
//        label.sizeToFit()
//
//        let image = UIImage(named: "Edit")
//        let imageView = UIImageView(image: image)
//        //imageView.frame = CGRect(x: view.frame.maxX, y: view.center.y, width: 50, height: 50)
//        print(view.frame.maxX)
//        imageView.layoutMargins.right = 42
//        imageView.layoutMargins.left = 200
//
//        //label.layoutMargins.left = 26
//        //label.layoutMargins.top = 42
//        //label.layoutMargins.bottom = 42
//        view.addSubview(label)
//        view.addSubview(imageView)
//
//        return view
        let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! FormPreviewHeaderView
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
//
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
        headerview.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        return headerview
    }
    
    @objc func editSectionClicked(sender: UIGestureRecognizer) {
        if let section = sender.view {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
            vc.formContent = self.formContent
            vc.formData = self.formData
            vc.formFillInStep = section.tag
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        
        let section = formSections[indexPath.section]
        if let field = section.fields?[indexPath.row] {
            if let name = field.name {
                cell.leftLabel.text = name
                cell.rightLabel.text = formContent[name]
            }
        }
        return cell
    }
}

extension FormPreviewViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
