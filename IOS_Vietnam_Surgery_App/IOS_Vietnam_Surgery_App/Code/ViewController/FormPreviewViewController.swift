//
//  FormPreviewViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/4/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormPreviewViewController : UIViewController {
    
    @IBOutlet weak var formDataTableView: UITableView!
    
    
    @IBOutlet weak var formImagesCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollViewHeightContstraint: NSLayoutConstraint!
    public var formData: Form?
    
    public var formSections : [FormSection] = []
    
    public var formContent : [String:String] {
        get { return FormInputContainer.formContent }
        set { FormInputContainer.formContent = newValue }
    }
    
    public var formPictures : [UIImage] {
        get { return FormInputContainer.formPictures }
        set { FormInputContainer.formPictures = newValue }
    }
    
    //public var formContent : [String:String] = [:]
    
    public var formFillInStep = 0
    
    private var headerID = "FormPreviewHeaderView"
    
    private var editSectionId : Int?
    
    public var isPreexisting: Bool = false
    
    public var preexistingFileName : String?
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemsPerRow : CGFloat = 4
    public var dataChanged = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPreexisting {
            preexistingFileName = (self.formData?.name)! + "_" + formContent["Name"]! + "_" + formContent["District"]! + "_" + formContent["Birthyear"]! + ".json"
        }
        
        //formDataTableView.register(FormPreviewHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        updateTitle()
        setupTableView()
        setupCollectionView()
        setupAppBar()
    }
    
    public override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            var frame = self.formDataTableView.frame
            frame.size.height = self.formDataTableView.contentSize.height
            self.formDataTableView.frame = frame
            self.formDataTableView.setNeedsLayout()
            var colFrame = self.formImagesCollectionView.frame
            colFrame.origin.y = frame.maxY + 32
            colFrame.size.height = UIScreen.main.bounds.height - colFrame.origin.y - 16
            self.formImagesCollectionView.frame = colFrame
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if dataChanged {
            DispatchQueue.main.async {
                self.formDataTableView.reloadData()
                self.formImagesCollectionView.reloadData()
            }
            dataChanged = false
        }
    }
    
    func updateTitle() {
        var newTitle : String = ""
        
        if isPreexisting {
            newTitle += NSLocalizedString("formFillInViewControllerEditTitle", comment: "")
        }
        else {
            newTitle += NSLocalizedString("formFillInViewControllerNewTitle", comment: "")
        }
        
        if let formname = formData?.name {
            newTitle += " - " + formname
        }
        
        if let district = formContent[NSLocalizedString("District", comment: "")] {
            newTitle += " - " + district
        }
        
        if let name = formContent[NSLocalizedString("Name", comment: "")] {
            newTitle += " - " + name
        }
        
        if let birthYear = formContent[NSLocalizedString("Birthyear", comment: "")] {
            newTitle += " - " + birthYear
        }
        
        self.title = newTitle
    }
    
    func setupTableView() {
        formDataTableView.dataSource = self
        formDataTableView.delegate = self
        formDataTableView.register(UINib(nibName: "DoubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        formDataTableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
        //formDataTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupCollectionView() {
        formImagesCollectionView.dataSource = self
        formImagesCollectionView.delegate = self
        formImagesCollectionView.register(UINib(nibName: "CollectionViewImageCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewImageCell")
        formImagesCollectionView.register(UINib(nibName: "FormPreviewHeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FormPreviewHeaderCollectionView")
        let bgView = UIView()
        view.backgroundColor = UIColor.red //ColorHelper.lightGrayBackgroundColor()
        formImagesCollectionView.backgroundView = bgView
        formImagesCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagesClicked)))
    }
    
    func setupAppBar() {
        if (isPreexisting) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(askSaveForm))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("SaveAndNext", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(askSaveForm))
        }
    }
    
    @objc func imagesClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormPicturesViewController") as! FormPicturesViewController
        vc.formFillInStep = self.formFillInStep - 1
        vc.isPreexisting = true
        vc.formContent = self.formContent
        vc.formSections = self.formSections
        vc.formData = self.formData
        vc.formPreviewCallback = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func askSaveForm() {
        let alert = UIAlertController.init(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("SaveFormAlertMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
            (action: UIAlertAction) in
            self.saveForm()
            if self.isPreexisting {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.navigateToTemplateView()
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func saveForm() {
        guard let formData = self.formData else { return }
        formData.formContent = []
        formData.formImagesBytes = []
        
        formData.createdOn = DateTimeHelper.getCurrentDateTimeString()
        for field in formContent {
            formData.formContent!.append(FormContentKeyValuePair(name: field.key, value: field.value))
        }
        
        AppDelegate.savedDistrictValue = formContent[NSLocalizedString("District", comment: "")]!
        AppDelegate.savedVillageValue = formContent[NSLocalizedString("Village", comment: "")]
        AppDelegate.savedProvinceValue = formContent[NSLocalizedString("Province", comment: "")]
        AppDelegate.savedCommuneValue = formContent[NSLocalizedString("Commune", comment: "")]
        
        for image in formPictures {
            formData.formImagesBytes!.append(Array(image.jpegData(compressionQuality: 0.2)!))
        }
        
        guard let docDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        var fileName = ""
        if let existingFileName = self.preexistingFileName {
            fileName = existingFileName
        }
        else {
            fileName = (self.formData?.name)! + "_" + formContent[NSLocalizedString("Name", comment: "")]! + "_" + formContent[NSLocalizedString("District", comment: "")]! + "_" + formContent[NSLocalizedString("Birthyear", comment: "")]! + ".json"
        }
        let fileUrl = docDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(formData)
            try data.write(to: fileUrl, options: [])
            FormInputContainer.clear()
            navigationController?.popToRootViewController(animated: true)
            //navigateToTemplateView()
        }
        catch {
            print(error)
        }
        
    }
    
    func navigateToTemplateView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormTemplateViewController") as! FormTemplateViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FormPreviewViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formSections[section].fields?.count ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return formSections.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! FormPreviewHeaderView

        let bgView = UIView()
        bgView.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        headerview.backgroundView = bgView
        headerview.label.text = formSections[section].name
        headerview.label.font = headerview.label.font.withSize(34)
        headerview.image.image = UIImage(named: "Edit")
        headerview.image.isUserInteractionEnabled = true
        headerview.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editSectionClicked(sender:))))
        headerview.image.tag = section
        headerview.sectionNumber = section
        headerview.layoutMargins.top = 42
        headerview.layoutMargins.bottom = 42
        headerview.backgroundColor = ColorHelper.lightGrayBackgroundColor()
        return headerview
    }
    
    @objc func editSectionClicked(sender: UIGestureRecognizer) {
        if let section = sender.view {
            let sectionNum = section.tag
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormFillInViewController") as! FormFillInViewController
            vc.formFillInStep = sectionNum
            vc.formContent = self.formContent
            vc.formData = self.formData
            
            vc.isPreexisting = isPreexisting
            if isPreexisting {
                vc.formPreviewCallback = self
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLabelTableViewCell") as! DoubleLabelTableViewCell
        
        let section = formSections[indexPath.section]
        if let field = section.fields?[indexPath.row] {
            if let name = field.name {
                cell.leftLabel.text = name
                cell.rightLabel.text = formContent[name]
            }
        }
        return cell
    }
}

extension FormPreviewViewController : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}

extension FormPreviewViewController : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.formPictures.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewImageCell", for: indexPath) as! CollectionViewImageCell
        cell.imageView.image = self.formPictures[indexPath.row]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FormPreviewHeaderCollectionView", for: indexPath) as! FormPreviewHeaderCollectionView
        header.label.text = NSLocalizedString("Images", comment: "")
        header.label.font = header.label.font.withSize(34)
        header.image.image = UIImage(named: "Edit")
       
        return header
    }
}

extension FormPreviewViewController : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.formImagesCollectionView.frame.size.width, height: 38)
    }
}

extension FormPreviewViewController : UICollectionViewDelegate {
    
}

extension FormPreviewViewController : CallbackProtocol {
    public func setValue(data: Any) {
        if let formContent = data as? [String:String] {
            //self.formContent = formContent
        }
        else {
            //self.formData?.formPictures = data as! [UIImage]
        }
        self.dataChanged = true
    }
}
