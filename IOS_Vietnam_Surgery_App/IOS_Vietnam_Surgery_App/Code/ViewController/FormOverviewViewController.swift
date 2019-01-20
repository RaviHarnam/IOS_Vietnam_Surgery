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
    var filteredFormData = [Form]()
    public var searchBar: UISearchBar?
    private var spinner : UIActivityIndicatorView?
    private let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
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
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        setProgress(progress: 0)
        //searchController.searchBar.becomeFirstResponder() fout doet zich niet meer voor, testen op andere devices
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
            
            print("Filtering?", (formName?.contains(searchText) ?? false))
            
            return (formName?.contains(searchText) ?? false) || (name?.contains(searchText) ?? false) || (district?.contains(searchText) ?? false) || (imageCount.contains(searchText)) || (created?.contains(searchText) ?? false)
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
        self.title = NSLocalizedString("FormOverviewViewControllerTabTitle", comment: "")
    }
    

    func getFormData() {
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        spinner?.isHidden = false
        spinner?.startAnimating()
        let decoder = JSONDecoder()

        do {
            
            // isfetchting = true voor activity indicator

            let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
            let actualDirContents = directoryContents.filter { !$0.absoluteString.contains(".Trash") && !$0.absoluteString.contains(NSLocalizedString("LocalTemplatesFileName", comment: "")) }
            
//            var idx = 0
//            for file in actualDirContents {
//                if file.absoluteString.contains(NSLocalizedString("LocalTemplatesFileName", comment: ""))  {
//                    actualDirContents.remove(at: idx)
//                }
//                idx = idx + 1
//            }
//            idx = 0
//            for file in actualDirContents {
//                if file.absoluteString.contains(".Trash") {
//                    actualDirContents.remove(at: idx)
//                }
//                idx = idx + 1
//            }
            
            forms = []
            if actualDirContents.count == 0 { setProgress(progress: 1) }
            var index = 0
            for directoryContent in actualDirContents {
                //if directoryContent.absoluteString.contains(".Trash") { continue }
                print(directoryContent.absoluteString)
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
            DispatchQueue.main.async {
                self.tableViewFormoverview.reloadData()
            }
            spinner?.hide()
        }
            // isfetching = false voor activity indicator
        catch {
            // isfetching = false voor activity indicator
            // allert
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
                            print("Calling setProgress with progress: ", Float(index) / Float(formstosync.count * 2))
                            if self.deleteDataFromLocalStorage(filename: fileName) {
                                index = index + 1
                                print("Calling setProgress with progress: ", Float(index) / Float(formstosync.count * 2))
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
    
    @objc func deleteForm(_ rowToDelete: Int) {
        //if let row = sender.view?.tag {
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
                DispatchQueue.main.async {
                    self.tableViewFormoverview.reloadData()
                }
            }
            catch {
                print("Error writing: ", error)
            }
       // }
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("isFiltering: " ,isFiltering())
        return isFiltering() ? filteredFormData.count : forms.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formoverviewcell = tableView.dequeueReusableCell(withIdentifier: "FormOverviewTableViewCell", for: indexPath) as! FormOverviewTableViewCell
            
        let form = isFiltering() ? filteredFormData[indexPath.row] :  forms[indexPath.row]
        setHeaderText(cell: formoverviewcell)
        setContentText(cell: formoverviewcell, form: form)
        //formoverviewcell.trashIconImage.image = UIImage(named: "Delete")
        //formoverviewcell.trashIconImage.tag = indexPath.row
        //formoverviewcell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteForm(sender:))))
//        cell.textLabel?.text = form.username?
        
        return formoverviewcell
}
    
    func setHeaderText (cell: FormOverviewTableViewCell) {
        cell.FormNameLabelHeader.text = NSLocalizedString("FormNameLabelHeader", comment: "")
        cell.DistrictLabelHeader.text = NSLocalizedString("DistrictLabelHeader", comment: "")
        cell.PhotoLabelHeader.text = NSLocalizedString("PhotoLabelHeader", comment: "")
        cell.CreatedLabelHeader.text = NSLocalizedString("CreatedLabelHeader", comment: "")
        
        
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let form = self.forms[indexPath.row]
        navigateToFormPreview(form: form)
    }
    
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    // MARK: - UISearchResultsUpdating Delegate
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
