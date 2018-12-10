//
//  ImageFrameView.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/3/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class ImageFrameView : UIView {
    
    @IBInspectable
    public var bordered : Bool = true {
        didSet {
            if bordered {
                displayWithBorder()
            }
            else {
                displayWithoutBorder()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //displayWithBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //displayWithBorder()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        //displayWithBorder()
    }
    
    func displayWithBorder() {
        self.layer.borderColor = UIColor(named: "LightGrayBorderColor")!.cgColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        
        self.backgroundColor = UIColor.white;
    }
    
    func displayWithoutBorder() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = false
    }
}
