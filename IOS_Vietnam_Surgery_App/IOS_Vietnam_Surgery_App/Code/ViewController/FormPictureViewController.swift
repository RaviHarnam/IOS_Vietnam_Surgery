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
    
    @IBOutlet weak var leftTopLabel: UILabel!
    
    @IBOutlet weak var rightTopLabel: UILabel!
    
    @IBOutlet weak var imageTopLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupData()
        
        deleteBarButtonItem.action = #selector(deleteClicked)
        nextBarButtonItem.action = #selector(nextClicked)
    }
    
    func setupData() {
        leftTopLabel.text = NSLocalizedString("Pictures", comment: "")
        rightTopLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("StepXOutOfY", comment: "") as NSString, formFillInStep + 1, formFillInStep + 2) as String
        imageTopLabel.text = imageName + "_" + "\(self.imageNumber)" + ".jpg"
        
        if images.count > 0 {
            let image = images[imageNumber]
            imageView.image = image
        }
    }
    
    @objc func deleteClicked() {
        self.images.remove(at: imageNumber)
    }
    
    @objc func nextClicked() {
        if self.imageNumber + 1 >= self.images.count {
            self.imageNumber = 0
        }
        else {
            self.imageNumber = self.imageNumber + 1
        }
        setupData()
    }
}
