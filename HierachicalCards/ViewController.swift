//
//  ViewController.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/03/21.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController,CardButtonDelegate{
    var parentIds = [0]
    var currentLevel = 0
    var subject = Subject()
    var parentName = "Home"
    var toolbar_color = "#0074BF"
    let colors = ["#c93a40","#de9610","#a0c238","#56a764","#0074bf","#9460a0"]
    @IBAction func newFolder(sender: AnyObject) {
        showAlert()
    }
    @IBOutlet weak var cardScroll: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        
        self.title = parentName
        let title: UILabel = UILabel()
        title.frame = CGRectMake(0,0, 50, 50)
        title.text = parentName
        title.font = UIFont.boldSystemFontOfSize(15)
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        title.adjustsFontSizeToFitWidth = true
        title.lineBreakMode = NSLineBreakMode.ByClipping
        title.numberOfLines = 2
        self.navigationItem.titleView = title
        
        self.view.backgroundColor = UIColor.hexStr("#ffffff", alpha: 255)
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStr(self.toolbar_color, alpha: 255)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.toolbar.tintColor = UIColor.whiteColor()
        self.toolbar.barTintColor = UIColor.hexStr(self.toolbar_color, alpha: 255)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        createViews()
    }
    override func viewWillDisappear(animated: Bool) {
    }
    // Alert
    func showAlert() {
        var inputTextField: UITextField?
        // Style Alert
        let alert: UIAlertController = UIAlertController(title:"フォルダ新規作成",
            message: "フォルダ名を入力してください",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            CardDBHelper.add(self.currentLevel, parent: self.parentIds[self.currentLevel],type: 0, title: inputTextField!.text!, answer: "", subject: self.subject)
            self.createViews()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel) {
            action in print("Pushed CANCEL!")
        }
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            inputTextField = textField
            textField.placeholder = "FolderName"
        }
        
        // AddAction 記述順に反映される
        alert.addAction(otherAction)
        alert.addAction(cancelAction)
        
        // Display
        presentViewController(alert, animated: true, completion: nil)
        
    }
    func createViews(){
        let cards = CardDBHelper.find(parent: self.parentIds[self.currentLevel],subject_id: self.subject.id)
        let count = cards?.count
        let cardHeight:CGFloat = 50
        let cardMargin:CGFloat = 2
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        self.cardScroll.contentSize = CGSizeMake(myBoundSize.width,(CGFloat(count!) ?? 0) * (cardHeight+cardMargin))
        var idx:Int = 0
        for card in cards!{
            
            //cardbuttonの作成
            let button = CardButton(delegate: self,card: card, color: self.colors[(currentLevel+5)%5])
            self.cardScroll.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setConstraints(self.cardScroll, index: idx, height: cardHeight, margin: cardMargin)//制約を追加
            
            //lateLabelの作成
            let label = LateLabel(card: card)
            self.cardScroll.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setConstraints(cardScroll,left_button: button ,index: idx, height: cardHeight, margin: cardMargin)//制約を追加
            
            idx += 1
        }
    }

    func cardTransition(card: Card) {
        let second = self.storyboard?.instantiateViewControllerWithIdentifier("FirstVC") as! ViewController
        second.currentLevel = self.currentLevel + 1
        second.parentIds = self.parentIds
        second.parentIds.append(card.id)
        second.parentName = card.title
        second.subject = self.subject
        self.navigationController?.pushViewController(second, animated: true)
    }
    
    func showCard(card:Card){
        let showCardController: ShowCardController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowCardVC") as! ShowCardController
        showCardController.question = card.title
        showCardController.answer = card.answer
        showCardController.card = card
        self.navigationController?.pushViewController(showCardController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let createCardViewController: CreateCardController = segue.destinationViewController as! CreateCardController
        createCardViewController.level = self.currentLevel
        createCardViewController.parent = self.parentIds[self.currentLevel]
        createCardViewController.naviRightText = "作成"
        createCardViewController.naviTitle = "カード新規作成"
        createCardViewController.mode = "Create"
        createCardViewController.subject = self.subject
    }

}

