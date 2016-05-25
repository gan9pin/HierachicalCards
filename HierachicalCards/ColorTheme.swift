//
//  ColorTheme.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/02.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import RealmSwift

class ColorTheme: Object{
    
    dynamic var id = 0
    dynamic var color1 = ""
    dynamic var color2 = ""
    dynamic var color3 = ""
    dynamic var color4 = ""
    dynamic var color5 = ""
    dynamic var color6 = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
}
