//
//  DBHelper.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/21.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import Foundation
import RealmSwift

class CardDBHelper{
    static func add(level: Int, parent: Int,type: Int, title: String, answer: String, subject: Subject){
        let card = Card()
        
        card.id = lastId()
        card.level = level
        card.parent = parent
        card.type = type
        card.title = title
        card.answer = answer
        card.subject_id = subject.id

        let realm = try! Realm()
        try! realm.write {
        realm.add(card)
        }
        if card.type == 1{
            try! realm.write{
                subject.card_counts = subject.card_counts + 1
            }
        }
    }
    static func updateAll(newTitle: String,newAnswer: String, card: Card){
        
        let realm = try!Realm()
        try! realm.write{
            card.title = newTitle
            card.answer = newAnswer
        }
    }
    static func updateDay(card:Card){
        let realm = try!Realm()
        try! realm.write{
            card.updated_at = NSDate()
        }
    }
    static func find(parent id: Int,subject_id: Int) -> [Card]?{
        let realm = try! Realm()
        return realm.objects(Card).filter("parent = \(id)").filter("subject_id = %@",subject_id).map{$0}
    }
    static func findChildCard(id: Int, subject_id: Int) ->[Card]{
        var childCards:[Card] = []
        var parentIds:[Int] = [id]
        var tempParentIds: [Int] = []
        while(true){
            for id in parentIds{
                let tempCards:[Card] = self.find(parent: id,subject_id: subject_id)!
                for card in tempCards{
                    if card.type == 1{
                        childCards.append(card)
                    }else if card.type == 0{
                        tempParentIds.append(card.id)
                    }
                }
            }
            if tempParentIds.count == 0{break}
            parentIds = tempParentIds
            tempParentIds = []
        }
        return childCards
        
    }
    static func lastId() -> Int {
        let realm = try! Realm()
        if let user = realm.objects(Card).last {
            return user.id + 1
        } else {
            return 1
        }
    }
}
