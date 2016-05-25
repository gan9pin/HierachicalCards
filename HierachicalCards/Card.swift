//
//  User.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/21.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import RealmSwift

class Card: Object {
    
    dynamic var id = 0
    dynamic var level = 0
    dynamic var parent = 0
    dynamic var star = 0
    dynamic var priority = 0
    dynamic var type = 0
    dynamic var subject_id = 0
    dynamic var title = ""
    dynamic var answer = ""
    dynamic var blank = ""
    dynamic var image = ""
    dynamic var chackmark = false
    dynamic var updated_at = NSDate()
    dynamic var created_at = NSDate()
    
    override class func primaryKey() -> String {
        return "id"
    }
}
