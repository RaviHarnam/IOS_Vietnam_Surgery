//
//  FormPictureViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/19/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormPictureViewController : UIViewController {
    
    public var images : [UIImage] = []
    
    public var imageNumber : Int = 0
    
    public var imageName : String = ""
    
    public var formFillInStep : Int = 0
    
    public var formContent : [String:String] = [:]
    
    public var formData : Form?
    
    @IBOutlet weak var leftTopLabel: UILabel!
    
    @IBOutlet weak var rightTopLabel: UILabel!
    
    @IBOutlet weak var imageTopLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    public var callback : CallbackProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupData()
        setupSwipeGestures()
        
        deleteBarButtonItem.action = #selector(deleteClicked)
        if self.images.count >= 2 {
            nextBarButtonItem.isEnabled = true
            nextBarButtonItem.action = #selector(nextClicked)
        }
        else {
            nextBarButtonItem.isEnabled = false
            nextBarButtonItem.title = ""
            //nextBarButtonItem.image =
        }
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
    
    func setupData() {
        updateTitle()
        leftTopLabel.text = NSLocalizedString("Pictures", comment: "")
        rightTopLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("StepXOutOfY", comment: "") as NSString, formFillInStep + 1, formFillInStep + 2) as String
        imageTopLabel.text = imageName + "_" + "\(self.imageNumber)" + ".jpg"
        
        if images.count > 0 {
            let image = images[imageNumber]
            imageView.image = image
        }
    }
    
    func setupSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func deletePicture() {
        self.images.remove(at: imageNumber)
        self.callback?.setValue(data: self.images)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func swipedRight() {
        goToNext()
    }
    
    @objc func swipedLeft() {
        goToPrevious()
    }
    
    @objc func deleteClicked() {
        let alert = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Confirm_delete_picture", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in self.deletePicture() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func nextClicked() {
        goToNext()
    }
    
    func goToPrevious() {
        if self.imageNumber == 0 {
            self.imageNumber = self.images.count - 1
        }
        else {
            self.imageNumber = self.imageNumber - 1
        }
        setupData()
    }
    
    func goToNext() {
        if self.imageNumber + 1 >= self.images.count {
            self.imageNumber = 0
        }
        else {
            self.imageNumber = self.imageNumber + 1
        }
        setupData()
    }
}
