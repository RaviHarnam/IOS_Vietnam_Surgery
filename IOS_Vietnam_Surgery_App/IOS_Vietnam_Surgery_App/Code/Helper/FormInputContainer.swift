//
//  FormInputContainer.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Vincent on 1/19/19.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation
import UIKit

public class FormInputContainer {
    public static var formContent : [String:String] = [:]
    public static var formPictures : [UIImage] = []
    
    public static func clear() {
        formContent = [:]
        formPictures = []
    }
}
