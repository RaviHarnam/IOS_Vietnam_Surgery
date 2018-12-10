//
//  DoubleLabelViewController.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/4/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class DoubleLabelTableViewCell : UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    public override func awakeFromNib() {
        
    }
    
    public override func prepareForReuse() {
        leftLabel.text = ""
        rightLabel.text = ""
    }
}
