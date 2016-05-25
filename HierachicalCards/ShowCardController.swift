//
//  ShowCardController.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/26.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit

class ShowCardController: UIViewController {
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionScroll: UIScrollView!
    @IBOutlet weak var answerScroll: UIScrollView!
    var question: String = ""
    var answer: String = ""
    var card: Card = Card()
    override func viewDidLoad() {
        self.title = "解答"
        let editButton: UIBarButtonItem = UIBarButtonItem(title: "編集", style: .Plain, target: self, action: "transition")
        self.navigationItem.setRightBarButtonItem(editButton, animated: true)
        self.questionLabel.text = question
        self.answerLabel.text = answer
        self.questionLabel.numberOfLines = 0
        self.answerLabel.numberOfLines = 0
        self.questionLabel.sizeToFit()
        self.answerLabel.sizeToFit()
        
        self.questionScroll.layer.borderWidth = 1
        self.questionScroll.layer.borderColor = UIColor.hexStr("d64541",alpha: 1).CGColor
        self.questionScroll.layer.cornerRadius = 8
        self.answerScroll.layer.borderWidth = 1
        self.answerScroll.layer.borderColor = UIColor.hexStr("22A7F0",alpha: 1).CGColor
        self.answerScroll.layer.cornerRadius = 8
        self.showAnswerButton.backgroundColor = UIColor.hexStr("22A7F0",alpha: 1)
        self.showAnswerButton.addTarget(self, action: "clickShowAnswer:", forControlEvents: .TouchUpInside)
    }
    override func viewWillAppear(animated: Bool) {
        
        self.questionLabel.text = self.question
        self.answerLabel.text = self.answer
        self.questionLabel.sizeToFit()
        self.answerLabel.sizeToFit()
        
    }
    override func viewDidLayoutSubviews() {
        self.answerScroll.contentSize = CGSizeMake(self.answerScroll.bounds.width, self.answerLabel.bounds.height)
        self.questionScroll.contentSize = CGSizeMake(self.questionScroll.bounds.width, self.questionLabel.bounds.height)
    }
    func clickShowAnswer(button:UIButton){
        button.hidden = true
        CardDBHelper.updateDay(self.card)
        
    }
    func transition(){
        let createCardController: CreateCardController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateCardVC") as! CreateCardController
        createCardController.question = self.questionLabel.text!
        createCardController.answer = self.answerLabel.text!
        createCardController.mode = "Update"
        createCardController.card = self.card
        createCardController.showCardController? = self
        createCardController.naviRightText = "更新"
        createCardController.naviTitle = "カード編集"
        self.navigationController?.pushViewController(createCardController, animated: true)
    }
}
