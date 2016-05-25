//
//  SubjectTableViewController.swift
//  HierachicalCards
//
//  Created by YutoTani on 2016/04/03.
//  Copyright © 2016年 YutoTani. All rights reserved.
//

import UIKit
import RealmSwift

class SubjectTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var subjectArray:NSMutableArray = []
    var subject = Subject()
    @IBOutlet weak var tableView: UITableView!
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectArray.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        let subject = subjectArray[indexPath.row] as! Subject
        let subtitle = tableView.viewWithTag(1) as! UILabel
        subtitle.text = String(subject.name)
        
        let card_cnt = subject.card_counts
        var study_time = String(subject.study_time).characters.split(".").map{String($0)}
        if(study_time[1].utf16.count == 1){
            study_time[1] = study_time[1] + "0"
        }
        let foldertext = tableView.viewWithTag(2) as! UILabel
        foldertext.text = "カード登録数：\(card_cnt)枚  総勉強時間：\(study_time[0])時間\(60 * Int(study_time[1])! / 100)分"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstVC") as! ViewController
        let subject = subjectArray[indexPath.row] as! Subject
        viewController.subject = subject
        viewController.parentName = subject.name
        self.tabBarController?.tabBar.hidden = true
        Subject.studyTime = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
        self.subject = subject
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteDatabase()
        self.title = "ホーム"
        let btn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createSubject")
        self.navigationItem.rightBarButtonItem = btn
        tableView.delegate = self
        tableView.dataSource = self
        subjectArray = []
        let subjects = SubjectDBHelper.findAll()
        for subject in subjects!{
            subjectArray.addObject(subject)
            Subject.studyTime = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
        }
        
        
    }
    
    func deleteDatabase(){
        
        if let path = Realm.Configuration.defaultConfiguration.path {
            try! NSFileManager().removeItemAtPath(path)
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        if((self.tabBarController?.tabBar.hidden != false)){
            SubjectDBHelper.plusSubjectTime(self.subject)
        }
        self.tabBarController?.tabBar.hidden = false
        Subject.studyTime = NSDate(timeIntervalSinceNow:NSTimeInterval(NSTimeZone.systemTimeZone().secondsFromGMT))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSubject(){
        var inputTextField: UITextField?
        // Style Alert
        let alert: UIAlertController = UIAlertController(title:"暗記帳の新規作成",
            message: "教科を入力してください",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let otherAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            SubjectDBHelper.createSubject(inputTextField!.text!)
            self.viewDidLoad()
            self.tableView.reloadData()
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
        
        presentViewController(alert, animated: true, completion: nil)
        
    }

    
}
