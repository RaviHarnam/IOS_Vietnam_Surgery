//
//  FormOverviewViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 03/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import UIKit

class FormOverviewViewController: UIViewController {
    
    public var formData: Form?
    private var forms : [Form] = []
    var filteredFormData = [Form]()
    public var searchBar: UISearchBar?
    private let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableViewFormoverview: UITableView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressViewLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupProgressView()
       //setupSearchBar()
        //getFormData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProgress(progress: 0)
        getFormData()
    }
    
    func setupProgressView() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        //setProgress(progress: 0)
        //progressView.progress = 0.0
        //progressView.isHidden = true
        progressViewLabel.text = "0%"
        //progressViewLabel.isHidden = true
    }
    
    func setupSearchBar () {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search on name only"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        

    }
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFormData = forms.filter({( form : Form) -> Bool in
            return form.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        
        DispatchQueue.main.async {
            self.tableViewFormoverview.reloadData()
        }
        
    }

    
    func setupTableView() {

        self.tableViewFormoverview.dataSource = self
        self.tableViewFormoverview.delegate = self
        
        self.tableViewFormoverview.rowHeight = 100
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewFormoverview.refreshControl = refreshControl
        tableViewFormoverview.addSubview(refreshControl)
        
        self.tableViewFormoverview.register(UINib(nibName: "FormOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FormOverviewTableViewCell")
        
        
    }
    
    @objc func refresh() {
        getFormData()
        self.refreshControl.endRefreshing()
    }
    
    func setupNavigationBar() {
        //Block back navigation
        navigationItem.hidesBackButton = true
        //Set sync imageitem to appear
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkIfUserIsLoggedInForSync))
//           navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        self.searchBar = UISearchBar()
//        searchBar?.placeholder = "Search on name only"
//        searchBar?.sizeToFit()
////        if let searchbar = searchBar {
//            searchbar.delegate = self as! UISearchBarDelegate
//        }
//
//        navigationItem.titleView = searchBarΩ
        //setupSearchBar()
    }
    

    func getFormData() {
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let decoder = JSONDecoder()

        do {

            let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
            let actualDirContents = directoryContents.filter { !$0.absoluteString.contains(".Trash") }
            
            forms = []
            //if actualDirContents.count > 0 { setProgress(progress: 0) }
            var index = 0
            for directoryContent in actualDirContents {
                //if directoryContent.absoluteString.contains(".Trash") { continue }
                let string = try String(contentsOf: directoryContent, encoding: .utf8)
                let data = string.data(using: .utf8)
                
                let decodedUserObject = try? decoder.decode(Form.self, from: data!)
            
                forms.append(decodedUserObject!)
                //let progress = Float(index) / Float(directoryContents.count)
                //print(progress)
                index = index + 1
                print(Float(index) / Float(actualDirContents.count))
                setProgress(progress: Float(index) / Float(actualDirContents.count))
            }
            self.tableViewFormoverview.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
   }
    
    
    @objc func checkIfUserIsLoggedInForSync() {
        if (AppDelegate.authenticationToken != nil) {
            if(forms != nil) {
                syncFormDataAlert()
            }
            else {
                noDataAlert()
            }
        }
        else {
            print("else login first")
            loginFirstAlert()
        }
        
    }
    
    @objc func noDataAlert() {
        let alert = UIAlertController(title: NSLocalizedString("No Forms", comment: ""), message: NSLocalizedString("NoFormsToCommit", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
   @objc func syncFormDataAlert() {
        
        let alert = UIAlertController(title: NSLocalizedString("Synchronization", comment: ""), message: NSLocalizedString("QuestionSync", comment: ""), preferredStyle: .alert)
        
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
        
        if (BaseAPIManager.isConnectedToInternet())
        {
            self.syncFormData()
        }
        else
        {
            var alert = AlertHelper.NoInternetAlert()
            self.present(alert, animated: true)
        }
    }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func loginFirstAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Login", comment: ""), message: NSLocalizedString("LoginFirstMsg", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: {(action: UIAlertAction)
            in self.navigateToLogin()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func syncFormData() {
       var formstosync : [FormContent] = []

        if(AppDelegate.authenticationToken != nil) {
            for form in self.forms {
                formstosync.append(FormContent(formid: form.id, formContent: form.formContent!, images: form.formImagesBytes!))
            }
            var index = 0
            if formstosync.count > 0 { setProgress(progress: 0) }
            for formtosync in formstosync {
                FormContentAPIManager.syncFormContent(form: formtosync)?.responseJSON(completionHandler: {
                    (response) in
                    
                    //Response 200, bepaal template naam via response formcontent - naam terugzoeken in folder = deleten
                    if response.response?.statusCode == 200 {
                        self.setProgress(progress: self.progressView.progress)
                        if let jsondata = response.data {
                            let decoder = JSONDecoder()
                            let decodedFormContentObject = try? decoder.decode(FormContent.self, from: jsondata)
                            let nameValue = decodedFormContentObject?.formContent?.first(where: {  $0.name?.lowercased() == "name" })!.value
                            let districtValue = decodedFormContentObject?.formContent?.first(where: {$0.name?.lowercased() == "district"})!.value
                            let birthYearValue = decodedFormContentObject?.formContent?.first(where:{$0.name?.lowercased() == "birthyear"})!.value
                            let formData = decodedFormContentObject?.formTemplateName
                            
                            let fileName = (formData)! + "_" + nameValue! + "_" + districtValue! + "_" + birthYearValue! + ".json"
                            index = index + 1
                            self.setProgress(progress: Float(index) / Float(formstosync.count * 2))
                            if self.deleteDataFromLocalStorage(filename: fileName) {
                                index = index + 1
                                self.setProgress(progress: Float(index) / Float(formstosync.count * 2))
                            }
                        }
                    }
                })
            }
        }
        else
        {
            print("Authenticatie voor sync is: " , AppDelegate.authenticationToken)
        }
    }
    
    func setProgress(progress: Float) {
        if progressView.isHidden {
            progressView.isHidden = false
            progressViewLabel.isHidden = false
        }
        
        if progress.isEqual(to: 1) {
            progressView.isHidden = true
            progressViewLabel.text = "0%"
            progressViewLabel.isHidden = true
            progressView.progress = 0.0
        }
        
        progressView.progress = progress
        progressViewLabel.text = String(Int(progress * 100)) + "%"
    }
    
    
    func deleteDataFromLocalStorage(filename: String) -> Bool {
            let fileNameToDelete = filename
            guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        
            do {
                 let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    if file.absoluteString.contains(fileNameToDelete) {
                        do {
        
                            
                            try FileManager.default.trashItem(at: file.absoluteURL, resultingItemURL: nil)
                            
                            
                            DispatchQueue.main.async {
                                self.forms.removeAll()
                                self.tableViewFormoverview.reloadData()
                            }
                            return true
                        }
                        catch {
                            print("Error deleting file: ", file.absoluteString)
                            print(error)
                            return false
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
                return false
            }
        return false
}
    
//    @objc func askSaveForm() {
//        let alert = UIAlertController.init(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("SaveFormAlertMessage", comment: ""), preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
//            (action: UIAlertAction) in
//            self.saveForm()
//            self.navigateToTemplateView()
//        }))
//        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
}


extension FormOverviewViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("isFiltering: " ,isFiltering())
        return isFiltering() ? filteredFormData.count : forms.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formoverviewcell = tableView.dequeueReusableCell(withIdentifier: "FormOverviewTableViewCell", for: indexPath) as! FormOverviewTableViewCell
            
        let form = isFiltering() ? filteredFormData[indexPath.row] :  forms[indexPath.row]
        setHeaderText(cell: formoverviewcell)
        setContentText(cell: formoverviewcell, form: form)
        
    
//        cell.textLabel?.text = form.username?
        
        return formoverviewcell
}
    
    func setHeaderText (cell: FormOverviewTableViewCell) {
        
        cell.FormNameLabelHeader.text = NSLocalizedString("FormNameLabelHeader", comment: "")
        cell.DistrictLabelHeader.text = NSLocalizedString("DistrictLabelHeader", comment: "")
        cell.PhotoLabelHeader.text = NSLocalizedString("PhotoLabelHeader", comment: "")
        cell.CreatedLabelHeader.text = NSLocalizedString("CreatedLabelHeader", comment: "")
        DispatchQueue.main.async {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
    }
    
    func setContentText (cell: FormOverviewTableViewCell, form: Form)
    {
        cell.NameLabel.text = form.name
    
        if let districtValue = form.formContent!.first(where: {$0.name == NSLocalizedString("District", comment: "")})
        {
            cell.DistrictLabel.text = districtValue.value
        }
        
        if let formNameValue = form.formContent!.first(where: {$0.name == NSLocalizedString("Name", comment: "")})
        {
            cell.FormNameLabel.text = formNameValue.value
        }
        
        cell.PhotoLabel.text = String(form.formImagesBytes?.count ?? 0)
        
        cell.CreatedLabel.text = form.createdOn
    }
}

extension FormOverviewViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let form = self.forms[indexPath.row]
        
        navigateToFormPreview(form: form)
        
    }
    
    
    private func navigateToFormPreview (form: Form) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let formPreviewVC = mainStoryboard.instantiateViewController(withIdentifier: "FormPreviewViewController") as! FormPreviewViewController
        formPreviewVC.isPreexisting = true
        formPreviewVC.formData = form
        formPreviewVC.formContent = FormHelper.getFormContentDicFromArr(content: form.formContent!)
        let template = FormHelper.getFormTemplateFromJson(json: form.formTemplate!)
        formPreviewVC.formSections = template!.sections!
       
        print("navigating to formpreview with: " + self.navigationController.debugDescription)
        navigationController!.pushViewController(formPreviewVC, animated: true)
    }
    
    private func navigateToLogin() {
        let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)
        
        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController!.pushViewController(loginVC, animated: true)
    }
}


extension FormOverviewViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
//        guard 1 == 2 else {
//            return
//        }
//        if !searchController.searchBar.text!.isEmpty
//     {
//            filterContentForSearchText(searchController.searchBar.text!)
//        }

    }
}
