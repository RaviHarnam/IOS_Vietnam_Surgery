//
//  ViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 14/11/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import UIKit

class FormTemplateViewController: UIViewController {

    @IBOutlet weak var chooseFormLabel: UILabel!
    @IBOutlet weak var formTemplateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        
    }
    
    func setupNavigationBar() {
        //Block back navigation
        navigationItem.hidesBackButton = true
        //Set sync imageitem to appear
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(syncCLicked))
    }
    
    @objc
    func syncCLicked() {
        
    }

}

