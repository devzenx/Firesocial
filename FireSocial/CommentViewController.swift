//
//  CommentViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 10/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noCommentLbl : UILabel!
    @IBOutlet weak var commentTextField : UITextField!
    var commentRef : Firebase!
    var comments = [Comment]()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.estimatedRowHeight = 121
        tableView.rowHeight = UITableViewAutomaticDimension
      
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.title = "Comments"
        
        commentRef.observeEventType(.Value) { (snapshot : FDataSnapshot!) in
            self.comments = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots.reverse() {
                    if (snap.value as? Dictionary<String,AnyObject>) != nil {
                        let key = snap.key
                        self.commentRef.childByAppendingPath(key).observeEventType(.Value, withBlock: { (snapshot : FDataSnapshot!) in
                            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                                for snap in snapshots {
                                    print(snap.key)
                                   
                                    if let dict = snap.value as? Dictionary<String,AnyObject> {
                                    let comment = Comment(userId: snap.key, dictionary: dict)
                                        print(dict)
                                        self.comments.append(comment)
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        })
                        
                    }
                }
                
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? CommentTableViewCell {
            cell.configureCell(comments[indexPath.row])
            
            return cell
        }
        else {
            return CommentTableViewCell()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count == 0 {
            noCommentLbl.hidden = false
            print("zsa")
        
        }else {
            noCommentLbl.hidden = true
        }
        return comments.count
    }
    @IBAction func addComment(sender : UIButton) {
        if let commentTxt = commentTextField.text where commentTxt != "" {
            let ref = commentRef.childByAutoId().childByAppendingPath( NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String)
            let comment = ["commentText" : commentTxt,"timeStamp" :"\(NSDate().timeIntervalSince1970)"]
            ref.setValue(comment, withCompletionBlock: { (error, fireBase) in
                if error == nil {
                    self.commentTextField.text = ""
                    self.tableView.reloadData()
                }else {
                    print(error)
                }
              
            })
           
        }
         self.tableView.reloadData()
    
    }
}
