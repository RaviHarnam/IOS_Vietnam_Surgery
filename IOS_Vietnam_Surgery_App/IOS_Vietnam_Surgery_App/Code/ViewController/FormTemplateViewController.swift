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
    
    private var formTemplates : [Form]?
    private var spinner : UIActivityIndicatorView?
    
    private var isFetching : Bool = false {
        willSet(newIsFetching) {
            if newIsFetching {
                spinner?.startAnimating()
            }
            else {
                spinner?.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        self.title = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        self.chooseFormLabel.text = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        self.chooseFormLabel.textColor = ColorHelper.lightGrayTextColor()
        
        setupTableView()
        setupNavigationBar()
        setupSpinner()
        
        getFormTemplatesAsync()
    }
    
    func setupTableView() {
        self.formTemplateTableView.dataSource = self
        self.formTemplateTableView.delegate = self
        self.formTemplateTableView.register(UINib(nibName: "SimpleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleLabelTableViewCell")
    }
    
    func setupNavigationBar() {
        //Block back navigation
        navigationItem.hidesBackButton = true
        //Set sync imageitem to appear
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(syncCLicked))
    }
    
    func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        self.spinner = spinner
        view.addSubview(spinner)
    }
    
    @objc
    func syncCLicked() {
        getFormTemplatesAsync()
    }
    
    func getFormTemplatesAsync() {
        FormTemplateAPIManager.GetFormTemplates().responseData(completionHandler: {
            (response) in
            guard let responseData = response.data else { return }
            
            let decoder = JSONDecoder()
            let templates = try? decoder.decode([Form].self, from: responseData)
            self.formTemplates = templates
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
            }
        })
    }
}

extension FormTemplateViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formTemplates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "SimpleLabelTableViewCell") as! SimpleLabelTableViewCell
        
        DispatchQueue.main.async {
            tableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        if let template = formTemplates?[indexPath.row] {
            DispatchQueue.main.async {
                 tableCell.simpleLabel.text = template.name
            }
        }
        return tableCell
    }
}

extension FormTemplateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let template = formTemplates?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
            vc.formData = template
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}