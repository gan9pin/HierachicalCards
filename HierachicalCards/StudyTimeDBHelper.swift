//
//  StudyTimeDBHelper.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/16.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation
import RealmSwift

class StudyTimeDBHelper {
    
    static func findAll() -> [StudyTime]{
        let realm = try! Realm()
        return realm.objects(StudyTime).map{$0}
    }
    static func findAllSubject() -> [String]{
        let realm = try! Realm()
        let subtime = realm.objects(StudyTime)
        var subject:[String] = []
        for st in subtime{
            subject.append(st.subject)
        }
        return subject
    }
    static func studyTimeLog(subject_name:String,span:Double) -> (date:[String],time:[Double]){
        let now = NSDate.stripHoursFromDate(NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT)))
        let before = NSDate.stripHoursFromDate(NSDate.beforeDate(span))
        
        let realm = try! Realm()
        let subtime = realm.objects(StudyTime).filter("subject = %@", subject_name).filter("date >= %@", before).filter("date <= %@", now).sorted("date", ascending: true)
        var dates:[String] = []
        var times:[Double] = []
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        var count = 0
        for st in subtime{
            dates += [dateFormatter.stringFromDate(st.date)]
            times += [st.time]
            count++
        }
//        dates[dates.count - 1] = "Today"
        return (dates,times)
    }
}