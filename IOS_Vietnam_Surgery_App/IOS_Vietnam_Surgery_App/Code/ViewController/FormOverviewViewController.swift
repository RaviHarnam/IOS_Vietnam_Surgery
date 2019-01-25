//
//  FormOverviewViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 03/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import UIKit

public class FormOverviewViewController: UIViewController {
    
    public var formData: Form?
    private var forms : [Form] = []
    private var formsfromapi : [FormTemplatePlusContent] = []
    var filteredFormData = [Form]()
    public var searchBar: UISearchBar?
    private var spinner : UIActivityIndicatorView?
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isFetching = false
    @IBOutlet weak var tableViewFormoverview: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        spinner = BaseAPIManager.createActivityIndicatorOnView(view: self.view)
        
        setupTableView()
        setupNavigationBar()
        setupProgressView()
        setupSearchBar()
        
        //getFormData()
        refreshControl.beginRefreshing()
        refresh()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        self.resetProgress()
       // searchController.searchBar.becomeFirstResponder()
        //refreshControl.beginRefreshing()
        //getFormData()

    }
    
    func setupProgressView() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        //setProgress(progress: 0)
        //progressView.progress = 0.0
        //progressView.isHidden = true
        //progressViewLabel.text = "0%"
        //progressViewLabel.isHidden = true
    }
    
    func setupSearchBar () {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search on name only"
        ///navigationItem.searchController = searchController
        searchController.searchBar.sizeToFit()
        self.tableViewFormoverview.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        self.tableViewFormoverview.contentOffset = CGPoint(x: Double(0.0), y: Double(searchController.searchBar.frame.height))
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
            let searchText = searchText.lowercased()
            print("SearchText: ", searchText)
            let district = form.formContent!.first(
                where: {$0.name == NSLocalizedString("District", comment: "")})?.value?.lowercased()
            print("District: ", district)
            let formName = form.name?.lowercased()
            print("forname: ", formName)
            
            let name = form.formContent!.first(where: {$0.name == NSLocalizedString("Name", comment: "")})?.value?.lowercased()
            print("name: ", name)
            
            let imageCount = String(form.formImagesBytes?.count ?? 0)
            print("Imagecount: ", imageCount)
            
            let created = form.createdOn?.lowercased()
            print("Created: ", created)
            
            let birthyear = form.formContent!.first(
                where: {$0.name == NSLocalizedString("Birthyear", comment: "")})?.value?.lowercased()
            
            print("Filtering?", (formName?.contains(searchText) ?? false))
            
            return (formName?.contains(searchText) ?? false) || (name?.contains(searchText) ?? false) || (district?.contains(searchText) ?? false) || (imageCount.contains(searchText)) || (created?.contains(searchText) ?? false) || (birthyear?.contains(searchText) ?? false)
        })
        
        DispatchQueue.main.async {
            self.tableViewFormoverview.reloadData()
        }
    }
    
    func setupTableView() {
        
        self.tableViewFormoverview.dataSource = self
        self.tableViewFormoverview.delegate = self
        self.tableViewFormoverview.rowHeight = 110
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewFormoverview.refreshControl = refreshControl
        tableViewFormoverview.addSubview(refreshControl)
        
        self.tableViewFormoverview.register(UINib(nibName: "FormOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FormOverviewTableViewCell")
    }
    
    @objc func refresh() {
        print("Is refreshing?: ", refreshControl.isRefreshing)
        //if refreshControl.isRefreshing {
            //refreshControl.beginRefreshing()
        guard !isFetching else { return }
        isFetching = true
        getFormData(callback: {
            self.isFetching = false
            self.refreshControl.endRefreshing()
        })
        //isFetching = false
        //self.refreshControl.endRefreshing()
            //self.refreshControl.endRefreshing()
        //}
        resetProgress()
    }

    private func resetProgress() {
        progressView.progress = 0
        progressViewLabel.text = "0%"
        progressView.isHidden = true
        progressViewLabel.isHidden = true
        
    }
    
    func setupNavigationBar() {
        //Block back navigation
        navigationItem.hidesBackButton = true
        //Set sync imageitem to appear
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "upload"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkIfUserIsLoggedInForSync))
        navigationItem.rightBarButtonItem?.isEnabled = false
     
        self.title = NSLocalizedString("FormOverviewViewControllerTabTitle", comment: "")
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
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            (action: UIAlertAction) in
            if (BaseAPIManager.isConnectedToInternet()) {
                self.attemptSync()
            }
            else {
                let alert = AlertHelper.noInternetAlert()
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
    
    func getFormData(callback: @escaping () -> Void) {
        //self.isFetching = true
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        var directoryContents: [URL]
        spinner?.show()
        let decoder = JSONDecoder()
        
        do {
             directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
            let actualDirContents = directoryContents.filter { !$0.absoluteString.contains(".Trash") && !$0.absoluteString.contains(NSLocalizedString("LocalTemplatesFileName", comment: "")) }
            
            self.forms = []
            if actualDirContents.count == 0 {
                self.setProgress(progress: 1)
            }
            else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            DispatchQueue.global(qos: .background).async {
                self.isFetching = true
                for index in 1...actualDirContents.count {
                    let string = try? String(contentsOf: actualDirContents[index - 1], encoding: .utf8)
                    let data = string!.data(using: .utf8)
                    
                    let decodedUserObject = try? decoder.decode(Form.self, from: data!)
                    
                    self.forms.append(decodedUserObject!)
                    
                    print("Adding a form on index: " + String(index) + " with isFetching: " + String(self.isFetching))
                    print("GetFormData Progress: ", Float(index) / Float(actualDirContents.count))
                    
                    // if((actualDirContents.count - 1) == index) {
                    
                    DispatchQueue.main.async {
                        self.setProgress(progress: Float(index) / Float(actualDirContents.count))
                    }
           
                }
        
                DispatchQueue.main.async {
                    //self.refreshControl.endRefreshing()
                    //self.isFetching = false
                    print(self.refreshControl.isRefreshing)
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tableViewFormoverview.contentOffset = CGPoint.zero
                    })
                    self.tableViewFormoverview.reloadData()
                    self.spinner?.hide()
                }
                
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
        catch {
            // allert inbouwen
            print(error.localizedDescription)
            return
        }
    }
    
    func getFormsToSync() -> [FormContent] {
        var forms : [FormContent] = []
        for form in self.forms {
            forms.append(FormContent(formid: form.id, formContent: form.formContent!, images: form.formImagesBytes!))
        }
        return forms
    }
    
    func attemptSync() {
        if AppDelegate.authenticationToken == nil {
            loginFirstAlert()
        }
        else {
            resetProgress()
            
            syncAllForms()
        }
    }
    
    func syncAllForms() {
        let dispatchGroup = DispatchGroup()
        var progressIndex = 0
        var formIndex = 0
        var failedCount = 0
        let forms = getFormsToSync()
        for form in forms {
            //DispatchQueue.global().async(group: dispatchGroup) {
            dispatchGroup.enter()
            FormContentAPIManager.syncFormContent(form: form).response(completionHandler: {
                (response) in
                do {
                    print("Response Statuscode", response.response?.statusCode)
                    print("Response Message: ", String(data: response.data!, encoding: .utf8))
                    if response.response?.statusCode == 200 {
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            let formObject = try decoder.decode(FormContent.self, from: data)
                            progressIndex = progressIndex + 1
                            self.setProgress(progress: Float(progressIndex) / Float(forms.count * 2))
                            let fileName = FormHelper.getLocalStorageFileName(formObject)
                            if self.deleteDataFromLocalStorage(filename: fileName) {
                                progressIndex = progressIndex + 1
                                self.setProgress(progress: Float(progressIndex) / Float(forms.count * 2))
                                //self.forms.remove(at: formIndex)
                                //let index = self.forms.firstIndex(where: $0 == )
                                //self.forms.remove(at: <#T##Int#>)
                            }
                            else {
                                failedCount = failedCount + 1
                            }
                            formIndex = formIndex + 1
                        }
                    }
                }
                catch {
                    failedCount = failedCount + 1
                }
                dispatchGroup.leave()
            })
            
            //}
        }
        
        print(dispatchGroup.debugDescription)
        //dispatchGroup.wait()
        
        dispatchGroup.notify(queue: .main) {
            if failedCount > 0 {
                //NSString.localizedStringWithFormat(NSLocalizedString("StepXOutOfY", comment: "") as NSString, formFillInStep! + 1, formSections.count + 2) as String
                //let message = NSString.localizedStringWithFormat(NSLocalizedString("ErrorNotAllFormsSynced", comment: <#T##String#>), <#T##args: CVarArg...##CVarArg#>)
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSString.localizedStringWithFormat(NSLocalizedString("ErrorNotAllFormsSynced", comment: "") as NSString, failedCount) as String, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: {
                    (action: UIAlertAction) in
                    self.resetProgress()
                }))
                self.present(alert, animated: true)
            }
            //self.getFormData()
        }
    }
    
    
    func syncFormData() {
        resetProgress()
        var formstosync : [FormContent] = []
        
        if(AppDelegate.authenticationToken != nil) {
            for form in self.forms {
                formstosync.append(FormContent(formid: form.id, formContent: form.formContent!, images: form.formImagesBytes!))
            }
            var index = 0
            print("Progress before syncing: ", progressView.progress)
            if formstosync.count > 0 { setProgress(progress: 0) }
            var failedCount = 0
            var formNumber = 0
            for formtosync in formstosync {
                var succeeded = true
                FormContentAPIManager.syncFormContent(form: formtosync).responseJSON(completionHandler: {
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
                            print("Calling setProgress with progress: ", Float(index) / Float(formstosync.count * 2))
                            
                            if self.deleteDataFromLocalStorage(filename: fileName) {
                                index = index + 1
                                print("Calling setProgress with progress: ", Float(index) / Float(formstosync.count * 2))
                                self.forms.remove(at: formNumber)
                                self.setProgress(progress: Float(index) / Float(formstosync.count * 2))
                                
                            }
                            else {
                                succeeded = false
                            }
                            formNumber = formNumber + 1
                        }
                    }
                    else {
                        succeeded = false
                    }
                    if !succeeded {
                        failedCount = failedCount + 1
                    }
                })
            }
            if failedCount > 0 {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("ErrorNotAllFormsSynced", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: {
                    (action: UIAlertAction) in
                    self.resetProgress()
                }))
                self.present(alert, animated: true)
            }
        }
        else {
            print("Authenticatie voor sync is: " , AppDelegate.authenticationToken)
        }
        
        checkIfTherAreForms(formcount: forms.count)
//        if forms.count == 0 {
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//        DispatchQueue.main.async {
//            self.tableViewFormoverview.reloadData()
//        }
    }
    
    func failedFormsToUpload(failedCount: Int) {
        if failedCount > 0 {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "", style: .default, handler: {
                (action: UIAlertAction) in
                self.resetProgress()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func checkIfTherAreForms(formcount: Int) {
        if formcount == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        DispatchQueue.main.async {
            self.tableViewFormoverview.reloadData()
        }
    }
    
    @objc func deleteForm(_ rowToDelete: Int) {
        spinner?.show()
        let form = self.forms[rowToDelete]
        
        let name = form.formContent!.first(where: { $0.name == "Name" })!.value
        let district = form.formContent!.first(where: { $0.name == "District" })!.value
        let birthyear = form.formContent!.first(where: { $0.name == "Birthyear" })!.value
        
        let fileName = form.name! + "_" + name! + "_" + district! + "_" + birthyear! + ".json"
        
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = docDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileUrl)
            self.forms.remove(at: rowToDelete)
            if forms.count == 0 {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            DispatchQueue.main.async {
                self.tableViewFormoverview.reloadData()
            }
        }
        catch {
            print("Error writing: ", error)
        }
        spinner?.hide()
    }
    
    func deleteDataFromLocalStorage(filename: String) -> Bool {
        let fileNameToDelete = filename
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
            ///for file in directoryContents {
            //    if file.absoluteString.contains(fileNameToDelete) {
            let fileUrl = docDirectoryUrl.appendingPathComponent(filename)
                    do {
                        try FileManager.default.trashItem(at: fileUrl, resultingItemURL: nil)
                        return true
                    }
                    catch {
                        //print("Error deleting file: ", file.absoluteString)
                        print(error)
                        return false
                    }
             //   }
            //}
        }
        catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    func setProgress(progress: Float) {
        if progressView.isHidden {
            progressViewLabel.isHidden = false
            progressView.isHidden = false
        }
    
        if progress.isEqual(to: 1) {
            resetProgress()
        }
        
        self.progressView.setProgress(progress, animated: true)
        
        progressViewLabel.text = String(Int(progress * 100)) + "%"
    }
    

    
    func getAdminFormOverviewData (token: String, role: String) {
        
        FormManager.getAllFormContent(token: token, role: role, callBack: {
            (formoverviewdataArray) in
            self.spinner?.hide()
            if let formoverviewdata = formoverviewdataArray  {
                self.formsfromapi = formoverviewdata
                DispatchQueue.main.async {
                    self.tableViewFormoverview.reloadData()
                }
            }
        })
    }
}


extension FormOverviewViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("isFiltering: " ,isFiltering())
        return isFiltering() ? filteredFormData.count : forms.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formoverviewcell = tableView.dequeueReusableCell(withIdentifier: "FormOverviewTableViewCell", for: indexPath) as! FormOverviewTableViewCell
        
        let form = isFiltering() ? filteredFormData[indexPath.row] : forms[indexPath.row]
        setHeaderText(cell: formoverviewcell)
        setContentText(cell: formoverviewcell, form: form)
      
        if indexPath.row == self.forms.count {
            isFetching = false
        }
        
        return formoverviewcell
    }
    
    func setHeaderText (cell: FormOverviewTableViewCell) {
        cell.FormNameLabelHeader.text = NSLocalizedString("FormNameLabelHeader", comment: "")
        cell.DistrictLabelHeader.text = NSLocalizedString("DistrictLabelHeader", comment: "")
        cell.PhotoLabelHeader.text = NSLocalizedString("PhotoLabelHeader", comment: "")
        cell.CreatedLabelHeader.text = NSLocalizedString("CreatedLabelHeader", comment: "")
        cell.BirthYearHeader.text = NSLocalizedString("Birthyear", comment: "")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
    
    func setContentText (cell: FormOverviewTableViewCell, form: Form) {
        cell.NameLabel.text = form.name
        
        if let districtValue = form.formContent!.first(where: {$0.name == NSLocalizedString("District", comment: "")}) {
            cell.DistrictLabel.text = districtValue.value
        }
        
        if let formNameValue = form.formContent!.first(where: {$0.name == NSLocalizedString("Name", comment: "")}) {
            
            cell.FormNameLabel.text = formNameValue.value
        }
        
        if let birthYearValue = form.formContent!.first(where:{$0.name == NSLocalizedString("Birthyear", comment: "")}) {
            
            cell.BirthYearLabel.text = birthYearValue.value
        }
        
        cell.PhotoLabel.text = String(form.formImagesBytes?.count ?? 0)
        cell.CreatedLabel.text = form.createdOn
    }
}

extension FormOverviewViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let form = self.forms[indexPath.row]
        navigateToFormPreview(form: form)
    }
    
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let alert = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Confirmation_delete_form", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in self.deleteForm(indexPath.row) }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func navigateToFormPreview (form: Form) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let formPreviewVC = mainStoryboard.instantiateViewController(withIdentifier: "FormPreviewViewController") as! FormPreviewViewController
        formPreviewVC.isPreexisting = true
        let previewForm = form
        formPreviewVC.formPictures = FormHelper.decodeImageToUIImage(images: previewForm.formImagesBytes!)
        formPreviewVC.formData = previewForm
        formPreviewVC.formContent = FormHelper.getFormContentDicFromArr(content: form.formContent!)
        let template = FormHelper.getFormTemplateFromJson(json: form.formTemplate!)
        formPreviewVC.formSections = template!.sections!
        formPreviewVC.formFillInStep = template!.sections!.count + 1
        
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
    public func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty {
            filterContentForSearchText(searchController.searchBar.text!)
        }
        else {
            DispatchQueue.main.async {
                self.tableViewFormoverview.reloadData()
            }
        }
    }
}
