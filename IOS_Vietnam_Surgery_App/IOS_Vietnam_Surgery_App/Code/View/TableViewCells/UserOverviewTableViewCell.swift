//
//  UserOverviewTableViewCell.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 09/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class UserOverviewTableViewCell : UITableViewCell {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var userRoleLabel: UILabel!
    
    public override func prepareForReuse() {
        UserNameLabel.text = ""
    }
    
    public override func awakeFromNib() {
        
    }
}
