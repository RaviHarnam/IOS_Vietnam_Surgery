//
//  FormManagementViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/13/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormManagementViewController : UIViewController {
    
    @IBOutlet weak var formTemplateTableView: UITableView!
    
    private var formTemplates : [Form] = []
    
    
    private var dataChanged = false
    private var spinner : UIActivityIndicatorView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = NSLocalizedString("FormManagementViewControllerTabTitle", comment: "")
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        setupTabelview()
        getFormTemplatesAsync()
        setupAppBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
            }
            dataChanged = false
        }
    }
    
    func setupTabelview() {
        formTemplateTableView.dataSource = self
        formTemplateTableView.delegate = self
        formTemplateTableView.register(UINib(nibName: "SimpleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleLabelTableViewCell")
    }
    
    func setupAppBar() {
        var barButtonItems : [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Sync"), style: .plain, target: self, action: #selector(syncClikced)))
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(addClicked)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func addClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditViewController") as! FormTemplateEditViewController
        let form = Form()
        vc.isEditingForm = false
        form.formTemplate = NSLocalizedString("BaseTemplate", comment: "")
        vc.form = form
        vc.updateFormManagement = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func syncClikced() {
        getFormTemplatesAsync()
    }
    
    func getFormTemplatesAsync() {
        spinner?.show()
        FormTemplateAPIManager.getFormTemplates().responseData(completionHandler: {
            (response) in
            self.spinner?.hide()
            guard let responseData = response.data else { return }
            
            let decoder = JSONDecoder()
            let templates = try? decoder.decode([Form].self, from: responseData)
            self.formTemplates = templates ?? []
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
            }
        })
    }
    
    func showDeleteAlert(_ row: Int) {
        let alert = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Confirm_delete_formtemplate", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in self.deleteFormTemplate(row) }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error_delete_formtemplate", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func deleteFormTemplate(_ row: Int) {
        spinner?.show()
        let form = self.formTemplates[row]
        FormTemplateAPIManager.deleteFormTemplate(form.id!).response(completionHandler: {
            (response) in
            self.spinner?.hide()
            if response.response?.statusCode == 200 {
                self.formTemplates.remove(at: row)
                DispatchQueue.main.async {
                    self.formTemplateTableView.reloadData()
                }
                print("Deleted form template with statuscode 200")
            }
            else {
                self.showErrorAlert()
            }
        })
    }
//    func resizeTableView() {
//        if self.formTemplateTableView.frame.height > self.formTemplateTableView.contentSize.height {
//            DispatchQueue.main.async {
//                var frame = self.formTemplateTableView.frame
//                frame.size.height = self.formTemplateTableView.contentSize.height //CGFloat(self.formTemplates?.count ?? 0 * 40) //
//                self.formTemplateTableView.frame = frame
//            }
//        }
//    }
}

extension FormManagementViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formTemplates.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = NSLocalizedString("FormManagementViewControllerTitle", comment: "")
        label.textColor = ColorHelper.lightGrayTextColor()
        label.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        
        return label
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleLabelTableViewCell") as! SimpleLabelTableViewCell
        cell.backgroundColor = UIColor.white
        cell.simpleLabel.text = formTemplates[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension FormManagementViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditViewController") as! FormTemplateEditViewController
        vc.form = formTemplates[indexPath.row]
        vc.sectionNumber = indexPath.row
        vc.updateFormManagement = self
        vc.isEditingForm = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  .delete {
            showDeleteAlert(indexPath.row)
        }
    }
}

extension FormManagementViewController : CallbackProtocol {
    public func setValue(data: Any) {
        let dic = data as! Dictionary<Int?,FormPostPutModel>
        if let kvp = dic.first {
            let form = kvp.value
            if let index = kvp.key {
                self.formTemplates[index].name = form.name
                self.formTemplates[index].region = form.region
                self.formTemplates[index].formTemplate = form.formTemplate
            }
            else {
                let formModel = Form()
                formModel.name = form.name
                formModel.region = form.region
                formModel.formTemplate = form.formTemplate
                self.formTemplates.append(formModel)
            }
            self.dataChanged = true
        }
    }
}
