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
    
    @IBOutlet weak var chooseFormLabel: UILabel!
    @IBOutlet weak var formTemplateTableView: UITableView!
    
    private var formTemplates : [Form] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("FormManagementViewControllerTitle", comment: "")
        chooseFormLabel.text = NSLocalizedString("FormTemplates", comment: "")
        
        setupTabelview()
    }
    
    func setupTabelview() {
        formTemplateTableView.dataSource = self
        formTemplateTableView.delegate = self
        formTemplateTableView.register(UINib(nibName: "SimpleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleLabelTableViewCell")
    }
}

extension FormManagementViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formTemplates.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleLabelTableViewCell") as! SimpleLabelTableViewCell
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
