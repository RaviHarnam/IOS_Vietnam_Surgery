//
//  FormPicturesViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/3/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormPicturesViewController : UIViewController  {
    
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    
    @IBOutlet weak var picturesHeaderLabel: UILabel!
    
    @IBOutlet weak var picturesStepLabel: UILabel!
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow : CGFloat = 4
    
    public var formData: Form?
    
    public var formUIControls : [FormChoiceField]? = []
    
    public var formSection : FormSection? {
        get {
            return formSections[formFillInStep]
        }
    }
    
    public var formSections : [FormSection] = []
    
    public var formContent : [String:String] = [:]
    
    public var formFillInStep = 0
    
    private let imagePicker = UIImagePickerController()
    
    public var formPreviewCallback : CallbackProtocol?
    public var isPreexisting : Bool?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.picturesHeaderLabel.text = NSLocalizedString("Pictures", comment: "")
        self.picturesStepLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("StepXOutOfY", comment: "") as NSString, formFillInStep + 1, formSections.count + 2) as String
        updateTitle()
        setupCollectionView()
        setupAppBar()
    }
    
    func setupAppBar() {
        if isPreexisting == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: .plain, target: self, action: #selector(goToPreview))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToNextPage))
        }
    }
    
    @objc func goToPreview() {
        guard let formPictures = self.formData?.formPictures else {
            return
        }
        self.formPreviewCallback?.setValue(data: formPictures)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goToNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormPreviewViewController") as! FormPreviewViewController
        vc.formContent = self.formContent
        vc.formSections = self.formSections
        vc.formFillInStep = self.formFillInStep + 1
        vc.formData = self.formData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupCollectionView() {
        self.picturesCollectionView.dataSource = self
        self.picturesCollectionView.delegate = self
        self.picturesCollectionView.register(UINib(nibName: "CollectionViewImageCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewImageCell")
    }
    
    func updateTitle() {
        var newTitle : String = ""
        
        newTitle += NSLocalizedString("formFillInViewControllerNewTitle", comment: "")
        
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
}


extension FormPicturesViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (self.formData?.formPictures.count ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewImageCell", for: indexPath) as! CollectionViewImageCell
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderColor = UIColor(named: "LightGrayBorderColor")?.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.masksToBounds = false
        if indexPath.row == 0 {
            cell.imageView.image = UIImage(named: "Camera")!
        }
        else {
            let image = self.formData?.formPictures[indexPath.row - 1]
            cell.imageView.image = image
            
        }
        return cell
    }
}

extension FormPicturesViewController : UICollectionViewDelegateFlowLayout {
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
}

extension FormPicturesViewController : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error_NoCamera", comment: ""), preferredStyle: .alert)
                #if DEBUG
                    alert.addAction(UIAlertAction(title: "Ok (use Placeholder)", style: .default, handler: {
                        (alert: UIAlertAction) in
                       
                        self.formData?.formPictures.append(UIImage(named: "Placeholder")!)
                        DispatchQueue.main.async {
                            self.picturesCollectionView.reloadData()
                        }
                    }))
                #else
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil))
                #endif
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FormPictureViewController") as! FormPictureViewController
            vc.imageName = self.formContent[NSLocalizedString("Name", comment: "")]!
            vc.imageNumber = indexPath.row - 1
            vc.images = (self.formData?.formPictures)!
            vc.formFillInStep = self.formFillInStep
            vc.callback = self
            vc.formData = formData
            vc.formContent = formContent
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FormPicturesViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        self.formData?.formPictures.append(image)
        DispatchQueue.main.async {
            self.picturesCollectionView.reloadData()
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
}

extension FormPicturesViewController : CallbackProtocol {
    public func setValue(data: Any) {
        let images = data as! [UIImage]
        self.formData?.formPictures = images
        DispatchQueue.main.async {
            self.picturesCollectionView.reloadData()
        }
    }
    
    
}
