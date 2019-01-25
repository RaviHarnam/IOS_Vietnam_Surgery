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
    public var dataChanged : Bool?
    
    private var isFetching : Bool = false {
        willSet(newIsFetching) {
            if newIsFetching {
                spinner?.show()
            }
            else {
                spinner?.hide()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertForNoInternetConnection(isInternetConnect: checkForInternetConnectivity())
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        self.title = NSLocalizedString("FormTemplateViewControllerTabTitle", comment: "")

        
        setupTableView()
        setupNavigationBar()
        setupRefreshControl()
        getFormTemplatesAsync()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if dataChanged == true {
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
            }
            dataChanged = false
        }
    }
    
    func checkForInternetConnectivity() -> Bool {
        return BaseAPIManager.isConnectedToInternet()
    }
    
    func alertForNoInternetConnection(isInternetConnect : Bool) {
        
        if !isInternetConnect {
            
            let alert = AlertHelper.noInternetAlert()
            self.present(alert, animated: true)
        }
    }
    
    func setupTableView() {
        self.formTemplateTableView.estimatedRowHeight = 40
        self.formTemplateTableView.rowHeight = 40
        let bgView = UIView()
        bgView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        self.formTemplateTableView.backgroundView = bgView
        self.formTemplateTableView.tableFooterView = UIView(frame: .zero)
        self.formTemplateTableView.dataSource = self
        self.formTemplateTableView.delegate = self
        self.formTemplateTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
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
    
    
    @objc func refresh(){
        getFormTemplatesAsync()
        refreshControl?.endRefreshing()
    }
    
    @objc
    func syncCLicked() {
        getFormTemplatesAsync()
    }
    
    func getFormTemplatesAsync() {
        isFetching = true
        if BaseAPIManager.isConnectedToInternet() {
            getFormTemplatesFromInternetAsync()
        }
        else {
            getFormTemplatesFromDisk()
        }
    }
    
    func getFormTemplatesFromInternetAsync() {
        FormTemplateAPIManager.getFormTemplates().responseData(completionHandler: {
            (response) in
            self.spinner?.hide()
            guard let responseData = response.data else { return }
            
            let decoder = JSONDecoder()
            if let templates = try? decoder.decode([Form].self, from: responseData) {
                self.writeFormTemplatesToDisk(forms: templates)
                self.formTemplates = templates
                self.isFetching = false
                DispatchQueue.main.async {
                    self.formTemplateTableView.reloadData()
                }
            }
        })
    }
    
    func writeFormTemplatesToDisk(forms: [Form]) {
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = NSLocalizedString("LocalTemplatesFileName", comment: "")
        let fileUrl = docDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(forms)
            try data.write(to: fileUrl, options: [])
        }
        catch {
            print("Failure writing templates file", error)
        }
    }
    
    func getFormTemplatesFromDisk() {
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = NSLocalizedString("LocalTemplatesFileName", comment: "")
        let fileUrl = docDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let string = try String(contentsOf: fileUrl, encoding: .utf8)
            let forms = try JSONDecoder().decode([Form].self, from: string.data(using: .utf8)!)
            self.formTemplates = forms
            self.isFetching = false
            DispatchQueue.main.async {
                self.formTemplateTableView.reloadData()
            }
        }
        catch {
            print("Failure writing templates file", error)
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error_no_internet_failed_loading_file", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func getFilledInTemplateCount(_ templateName: String) -> Int {
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return 0 }
        let directoryContents = try? FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
        let actualDirContents = directoryContents!.filter { !$0.absoluteString.contains(".Trash") && !$0.absoluteString.contains(NSLocalizedString("LocalTemplatesFileName", comment: "")) }
        var count = 0
        for file in actualDirContents {
            let fileName = file.lastPathComponent
            let parts = fileName.split(separator: "_")
         
            print(parts.debugDescription)
            if (parts.first?.elementsEqual(templateName))! {
                count = count + 1
            }
        }
        return count
    }
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
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        tableCell.backgroundView = bgView
        //tableCell.backgroundView = Col
        tableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        if let template = formTemplates?[indexPath.row] {
            tableCell.leftLabel.text = template.name
            tableCell.rightLabel.text = String(getFilledInTemplateCount(template.name!))
        }
        return tableCell
    }
}

extension FormTemplateViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let template = formTemplates?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
            vc.formFillInStep = 0
            vc.formData = template
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

