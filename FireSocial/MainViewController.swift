//
//  MainViewController.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
import Fusuma
import Firebase
import Alamofire
import KRProgressHUD
class MainViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource,FusumaDelegate{
    
    @IBOutlet weak var postBtn: AnimatableButton!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var postTxt: AnimatableTextField!
    @IBOutlet weak var tableView : UITableView!
    
    var posts = [Post]()
    var isPicked : Bool = false
    var imagePicker : FusumaViewController!
    var imageLink : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 347
        tableView.rowHeight = UITableViewAutomaticDimension
        
        DataService.instance.REF_POST.observeEventType(.Value) { (snapshot : FDataSnapshot!) in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let dict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: dict)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        imagePicker = FusumaViewController()
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.pickImage(_:)))
        tap.numberOfTapsRequired = 1
        pickedImage.addGestureRecognizer(tap)
        pickedImage.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? PostTableViewCell {
            let post = posts[indexPath.row]
            cell.configureCell(post)
            return cell
        }else {
            return PostTableViewCell()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    @IBAction func post(sender: AnimatableButton) {
        KRProgressHUD.show(message: "Please wait!")
        if let postText = postTxt.text where postText != "" {
            if isPicked {
                UploadImageService.instance.upload(pickedImage.image!, completion: { (result) in
                    let post = ["imageUrl" : result , "likes" : 0 ,"postDescription" : postText]
                    DataService.instance.REF_POST.childByAutoId().setValue(post)
                    self.isPicked = false
                    self.pickedImage.image = UIImage(named: "camera")
                    self.postTxt.text = ""
                    KRProgressHUD.showSuccess(message: "Shared!")
                })
            }
        }else {
            KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.BlackColor, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: UIFont(name: "Avenir-Light", size: 13.0), message: "Fill All Areas!")
        }
    }
    func pickImage(sender : UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
        isPicked = true
    }
    func fusumaImageSelected(image: UIImage) {
        pickedImage.image = image
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
  
}
