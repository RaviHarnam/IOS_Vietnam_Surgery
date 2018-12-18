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
    private var refreshControl : UIRefreshControl?
    
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
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        self.title = NSLocalizedString("formTemplateTabBarItemTitle", comment: "")
        //self.chooseFormLabel.text = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        //self.chooseFormLabel.textColor = ColorHelper.lightGrayTextColor()
        self.navigationItem.title = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        
        setupTableView()
        setupNavigationBar()
        setupSpinner()
        setupRefreshControl()
        getFormTemplatesAsync()
    }
    
    func setupTableView() {
        self.formTemplateTableView.estimatedRowHeight = 40
        self.formTemplateTableView.rowHeight = 40
        self.formTemplateTableView.dataSource = self
        self.formTemplateTableView.delegate = self
        self.formTemplateTableView.register(UINib(nibName: "SimpleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleLabelTableViewCell")
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.formTemplateTableView.refreshControl = refreshControl
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
    
    @objc func refresh(){
        getFormTemplatesAsync()
        refreshControl?.endRefreshing()
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
    
    //Resizes the tableview if it currently is bigger than the size of the combined content
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

extension FormTemplateViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formTemplates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let label = UILabel()
        
        label.text = NSLocalizedString("formTemplateTableViewControllerTitle", comment: "")
        label.textColor = ColorHelper.lightGrayTextColor()
        label.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "SimpleLabelTableViewCell") as! SimpleLabelTableViewCell
        
        DispatchQueue.main.async {
            tableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        if let template = formTemplates?[indexPath.row] {
            //DispatchQueue.main.async {
                 tableCell.simpleLabel.text = template.name
            //}
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

