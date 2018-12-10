//
//  CollectionViewImageCell.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 12/3/18.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class CollectionViewImageCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    public override func awakeFromNib() {
        
    }
    
    public override func prepareForReuse() {
        imageView.image = nil
    }
}
