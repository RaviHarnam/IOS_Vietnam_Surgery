//
//  TableCellWithUIControl.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 11/29/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class TableCellWithUIControl : UITableViewCell {

    @IBOutlet weak var UIControlField: UIControl!
    
    @IBOutlet weak var UIControlFieldLabel: UILabel!
    
    override public func awakeFromNib() {
        
    }
    
    override public func prepareForReuse() {
        
    }
}
