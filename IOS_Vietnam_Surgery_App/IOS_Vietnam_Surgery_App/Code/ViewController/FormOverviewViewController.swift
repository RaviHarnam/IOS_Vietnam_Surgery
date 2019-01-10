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
    public var searchBar: UISearchBar?

    @IBOutlet weak var tableViewFormoverview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        //getFormData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFormData()
    }
    
    func setupTableView() {

        self.tableViewFormoverview.dataSource = self
        self.tableViewFormoverview.delegate = self
        
        self.tableViewFormoverview.rowHeight = 100
        
        self.tableViewFormoverview.register(UINib(nibName: "FormOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FormOverviewTableViewCell")
    }
    
    func setupNavigationBar() {
        //Block back navigation
        navigationItem.hidesBackButton = true
        //Set sync imageitem to appear
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkIfUserIsLoggedInForSync))
           navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sync"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.searchBar = UISearchBar()
        searchBar?.placeholder = "Search on name only"
        searchBar?.sizeToFit()
//        if let searchbar = searchBar {
//            searchbar.delegate = self as! UISearchBarDelegate
//        }
//
        navigationItem.titleView = searchBar
    }
    

    func getFormData() {

        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let decoder = JSONDecoder()

        do {

            let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
            forms = []
            for directoryContent in directoryContents {
                if directoryContent.absoluteString.contains(".Trash") { continue }
                let string = try String(contentsOf: directoryContent, encoding: .utf8)
                let data = string.data(using: .utf8)
                
                let decodedUserObject = try? decoder.decode(Form.self, from: data!)
            
                forms.append(decodedUserObject!)
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
        
        self.syncFormData()
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
//        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let decoder = JSONDecoder()
//        do {
//
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
//            for directoryContent in directoryContents {
//                let string = try String(contentsOf: directoryContent, encoding: .utf8)
//                let data = string.data(using: .utf8)
//
//                let decodedUserObject = try? decoder.decode(Form.self, from: data!)
//                formstosync.append(decodedUserObject!)
//            }
        if(AppDelegate.authenticationToken != nil) {
            for form in self.forms {
            
                for form in self.forms {
                    formstosync.append(FormContent(formid: form.id, formContent: form.formContent!, images: form.formImagesBytes!))
                }
            var index = 0
            for formtosync in formstosync {
                FormContentAPIManager.syncFormContent(form: formtosync)?.responseJSON(completionHandler: {
                    (response) in
                    
                    //Response 200, bepaal template naam via response formcontent - naam terugzoeken in folder = deleten
                    if response.response?.statusCode == 200 {
                        if let jsondata = response.data
                        {
                            let decoder = JSONDecoder()
                            let decodedFormContentObject = try? decoder.decode(FormContent.self, from: jsondata)
                            let nameValue = decodedFormContentObject?.formContent?.first(where: {  $0.name?.lowercased() == "name" })!.value
                            let districtValue = decodedFormContentObject?.formContent?.first(where: {$0.name?.lowercased() == "district"})!.value
                            let birthYearValue = decodedFormContentObject?.formContent?.first(where:{$0.name?.lowercased() == "birthyear"})!.value
                            let formData = decodedFormContentObject?.formTemplateName
                            
                            let fileName = (formData)! + "_" + nameValue! + "_" + districtValue! + "_" + birthYearValue! + ".json"
                            
                            self.deleteDataFromLocalStorage(filename: fileName)
                            
                            print("Formcontent komt binnen: ", decodedFormContentObject?.formContent?.first(where: {  $0.name?.lowercased() == "name" }))
                        }
                        
                    }
                    
                    print("Formcontent error: " , response)
                    print("Error: ", String(data: response.data!, encoding: .utf8))
                    //        }
                    //        catch {
                    //            print(error.localizedDescription)
                    //        }
                    
                })
            }
            }}

        else
        {
            print("Authenticatie voor sync is: " , AppDelegate.authenticationToken)
        }
    }
    
    
    
    func deleteDataFromLocalStorage(filename: String) {
            let fileNameToDelete = filename
            guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
    
            do {
                 let directoryContents = try FileManager.default.contentsOfDirectory(at: docDirectoryUrl, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    if file.absoluteString.contains(fileNameToDelete) {
                       let succeeded = try? FileManager.default.trashItem(at: file.absoluteURL, resultingItemURL: nil)
                    }

                }
            }
            catch {
                print(error.localizedDescription)
        }
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
        return forms.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let formoverviewcell = tableView.dequeueReusableCell(withIdentifier: "FormOverviewTableViewCell", for: indexPath) as! FormOverviewTableViewCell
        
        let formsarray = self.forms
            
        let form = formsarray[indexPath.row]
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
