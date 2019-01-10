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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("FormManagementViewControllerTabTitle", comment: "")
        
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
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(addClicked)))
        barButtonItems.append(UIBarButtonItem(image: UIImage(named: "Sync"), style: .plain, target: self, action: #selector(syncClikced)))
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func addClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateEditViewController") as! FormTemplateEditViewController
        vc.form = Form()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func syncClikced() {
        getFormTemplatesAsync()
    }
    
    func getFormTemplatesAsync() {
        FormTemplateAPIManager.getFormTemplates().responseData(completionHandler: {
            (response) in
            guard let responseData = response.data else { return }
            
            let decoder = JSONDecoder()
            let templates = try? decoder.decode([Form].self, from: responseData)
            self.formTemplates = templates ?? []
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
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
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FormManagementViewController : CallbackProtocol {
    public func setValue(data: Any) {
        let dic = data as! Dictionary<Int,FormPostPutModel>
        if let kvp = dic.first {
            let form = kvp.value
            self.formTemplates[kvp.key].name = form.name
            self.formTemplates[kvp.key].region = form.region
            self.formTemplates[kvp.key].formTemplate = form.formTemplate
            self.dataChanged = true
        }
    }
    
    
}
