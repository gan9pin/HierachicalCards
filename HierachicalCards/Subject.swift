//
//  Subject.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/02.
//  Copyright © 2016年 YutoTani. All rights reserved.
//


import RealmSwift

class Subject: Object {
    static var studyTime = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var color_theme = 0
    dynamic var card_counts = 0
    dynamic var study_time = 0.0
    
    override class func primaryKey() -> String {
        return "id"
    }
}
