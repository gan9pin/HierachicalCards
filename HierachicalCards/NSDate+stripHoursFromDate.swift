//
//  NSDate+stripHoursFromDate.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/17.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit

extension NSDate{
    
    static func stripHoursFromDate(date:NSDate) -> NSDate{
        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.stringFromDate(date)
        let newDate = dateFormatter.dateFromString(str)!
        return newDate
    }
}
