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
    
    //private var formPictures : [UIImage] = []
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //imagePicker.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        updateTitle()
        setupCollectionView()
        setupAppBar()
    }
    
    func setupAppBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToNextPage))
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
        //return 1 + formPictures.count
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
            //let image = formPictures[indexPath.row - 1]
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
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error_NoCamera", comment: ""), preferredStyle: .alert)
                #if DEBUG
                    alert.addAction(UIAlertAction(title: "Ok (use Placeholder)", style: .default, handler: {
                        (alert: UIAlertAction) in
                        //self.formPictures.append(UIImage(named: "Placeholder")!)
                        self.formData?.formPictures.append(UIImage(named: "Placeholder")!)
                        DispatchQueue.main.async {
                            self.picturesCollectionView.reloadData()
                        }
                    }))
                #else
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                #endif
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
}

extension FormPicturesViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Photo taken. Processing....")
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        //self.formPictures.append(image)
        self.formData?.formPictures.append(image)
        DispatchQueue.main.async {
            self.picturesCollectionView.reloadData()
        }
        
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Photo taken. Cancelled...")
    }
}
