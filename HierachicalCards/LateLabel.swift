//
//  LateLabel.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/27.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit

class LateLabel: UILabel{
    let colors = ["68BA4C","F9C732","FF5C57"]
    init(card:Card){
        super.init(frame: CGRectMake(0, 0, 0, 0))
        var late: Int = 0
        if card.type == 1{
            late = getLate(card)
        }else{
            late = getSumLate(card)
        }
        if card.type == 0 && late == 0{
            self.text = "-"
            self.backgroundColor = UIColor.grayColor()
            self.textAlignment = NSTextAlignment.Center
        }else{
            self.text = String(late)+"%"
            self.textAlignment = NSTextAlignment.Center
            if late > 50 && late <= 100 {
                self.backgroundColor = UIColor.hexStr(colors[0], alpha: 255)
            }else if late > 25 && late <= 50 {
                self.backgroundColor = UIColor.hexStr(colors[1], alpha: 255)
            }else if late >= 0 && late <= 25 {
                self.backgroundColor = UIColor.hexStr(colors[2], alpha: 255)
            }
        }
        self.textColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getLate(card:Card)->Int{
        let dateList:[Double] = [1,3,7,14,30,90]
        var late = round(100-((NSDate().timeIntervalSince1970 - card.updated_at.timeIntervalSince1970)/24/60/60/dateList[card.star]*100))
        if late < 0 {late = 0}
        return Int(late)
    }
    func getSumLate(card:Card)->Int{
        let childCards:[Card]? = CardDBHelper.findChildCard(card.id,subject_id: card.subject_id)
        if childCards != nil{
            var length: Int? = childCards?.count
            var sum = 0
            for card in (childCards)!{
                sum += getLate(card)
            }
            if length == 0{length = 1}
            let returnValue = sum/length!
            if returnValue < 0 {return 0}else{return returnValue}
        }
        return 0
    }
    func beforeDate(before:Double)->NSDate{
        return NSDate(timeIntervalSinceNow:Double((-24*60*60)*before))
    }
    
    func setConstraints(parent:UIView, left_button:UIButton, index:Int, height:CGFloat, margin:CGFloat){
        parent.addConstraints([
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal,
                toItem: parent, attribute: .Top, multiplier: 1.0, constant: (height+margin) * CGFloat(index)),
            NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: left_button, attribute: .Right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parent, attribute: .Height ,multiplier: 0, constant: height),
            NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: parent, attribute: .Width ,multiplier: 0.15, constant: 0)
            ])
    }
}