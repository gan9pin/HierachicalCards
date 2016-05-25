//
//  beforeDate.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/17.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit

extension NSDate{
    static func beforeDate(day:Double) -> NSDate{
        let now = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
        let newDate = NSDate(timeInterval: -60.0*60.0*24.0*day, sinceDate: now)
        return newDate
    }
}
