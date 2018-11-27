//
//  SimpleLabelTableViewCell.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/27/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class SimpleLabelTableViewCell : UITableViewCell {
    
    @IBOutlet weak var simpleLabel: UILabel!
    
    override public func awakeFromNib() {
        
    }
    
    override public func prepareForReuse() {
        simpleLabel.text = ""
    }
}
