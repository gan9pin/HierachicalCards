//
//  SubjectDBHelper.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/12.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import RealmSwift
import Realm

class SubjectDBHelper{
    
    static func subjectLastId() -> Int{
        let realm = try! Realm()
        if let user = realm.objects(Subject).last {
            return user.id + 1
        } else {
            return 1
        }
    }
    
    static func createSubject(name:String){
        let subject = Subject()
        subject.id = subjectLastId()
        subject.name = name
        let realm = try! Realm()
        try! realm.write{
            realm.add(subject)
        }
    }
    
    static func findAll() -> [Subject]?{
        let realm = try! Realm()
        return realm.objects(Subject).map{$0}
    }
    static func getSubjectNames(subjects:[Subject]) -> [String]{
        var strings:[String] = []
        for sub in subjects{
            strings += [sub.name]
        }
        return strings
    }
    static func getStudyTimes(subjects:[Subject]) -> [Double]{
        var times:[Double] = []
        for sub in subjects{
            times += [sub.study_time]
        }
        return times
    }
    static func plusSubjectTime(subject: Subject){
        let now = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
        //時間を0.00時間形式でtimeに格納する
        let time = round((now.timeIntervalSince1970 - Subject.studyTime.timeIntervalSince1970) / 60.0 / 60.0 * 100) / 100.0
        let realm = try! Realm()
        try! realm.write{
            subject.study_time += time
        }
        
        let study_time = StudyTime()
        let strip_hour_now = NSDate.stripHoursFromDate(now)//時間、分、秒を固定する
        let updateStudyTime = realm.objects(StudyTime).filter("date = %@", strip_hour_now).filter("subject = %@", subject.name)
        if(updateStudyTime.count == 0){
            study_time.date = strip_hour_now
            study_time.subject = subject.name
            study_time.time = time
            try! realm.write{
                realm.add(study_time)
            }
        }else{
            try! realm.write{
                updateStudyTime[0].time += time
            }
        }
        // 以下テスト用なので削除する
        for i in (0...365){
            let study_time = StudyTime()
            let strip_hour_now = NSDate.stripHoursFromDate(NSDate.beforeDate(Double(i))) //時間、分、秒を固定する
            let time = ( Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX) ) * (5 - 1) + 1
            let updateStudyTime = realm.objects(StudyTime).filter("date = %@", strip_hour_now).filter("subject = %@", subject.name)
            if(updateStudyTime.count == 0){
                study_time.date = strip_hour_now
                study_time.subject = subject.name
                study_time.time = Double(time)
                try! realm.write{
                    realm.add(study_time)
                }
            }
        }
        //以上テストようなので削除
    }
}
