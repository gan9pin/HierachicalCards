//
//  CreateCardController.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/26.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit
import RealmSwift

class CreateCardController: UIViewController {
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextView!
    @IBOutlet weak var navigationRightButton: UIBarButtonItem!
    
    var level = 0
    var parent = 0
    var question = ""
    var answer = ""
    var mode = ""
    var card: Card = Card()
    var subject: Subject = Subject()
    var showCardController: ShowCardController? = nil
    var naviRightText = ""
    var naviTitle = ""
    
    override func viewDidLoad() {
        questionText.layer.borderWidth = 1
        questionText.layer.borderColor = UIColor.hexStr("d64541",alpha: 1).CGColor
        questionText.layer.cornerRadius = 8
        answerText.layer.borderWidth = 1
        answerText.layer.borderColor = UIColor.hexStr("22A7F0",alpha: 1).CGColor
        answerText.layer.cornerRadius = 8
        navigationRightButton.title = naviRightText
        self.title = naviTitle
        self.questionText.text = question
        self.answerText.text = answer
    }
    @IBAction func addCard(sender: AnyObject) {
        if questionText.text == "" || answerText.text == "" {
            
        }else{
            if mode == "Create"{
                CardDBHelper.add(self.level, parent: self.parent, type: 1, title: questionText.text, answer: answerText.text, subject: self.subject)
                questionText.text = ""
                answerText.text = ""
            }else if mode == "Update"{
                CardDBHelper.updateAll(self.questionText.text, newAnswer: self.answerText.text, card: self.card)
                let show: ShowCardController = self.navigationController!.viewControllers[(navigationController?.viewControllers.count)! - 2] as! ShowCardController
                show.question = self.questionText.text
                show.answer = self.answerText.text
                navigationController?.popToViewController(show, animated: true)
            }
        }
    }
}
