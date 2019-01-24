//
//  DateTimeHelper.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 10/01/2019.
//  Copyright © 2019 Matermind. All rights reserved.
//

import Foundation

public class DateTimeHelper {
    static func getCurrentDateTimeString() -> String {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + "-" + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
    }
}
