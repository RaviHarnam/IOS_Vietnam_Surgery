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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("FormManagementViewControllerTitle", comment: "")
        
        setupTabelview()
        getFormTemplatesAsync()
    }
    
    func setupTabelview() {
        formTemplateTableView.dataSource = self
        formTemplateTableView.delegate = self
        formTemplateTableView.register(UINib(nibName: "SimpleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleLabelTableViewCell")
    }
    
    func getFormTemplatesAsync() {
        FormTemplateAPIManager.GetFormTemplates().responseData(completionHandler: {
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
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
