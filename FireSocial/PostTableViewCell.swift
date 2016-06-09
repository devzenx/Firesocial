//
//  PostTableViewCell.swift
//  FireSocial
//
//  Created by yusuf_kildan on 06/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher
import Firebase
import Social
import KRProgressHUD
class PostTableViewCell: UITableViewCell {
  
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var publishTimeLbl: UILabel!
    @IBOutlet weak var postDescriptionLbl: UILabel!
    @IBOutlet weak var mainImageView: AnimatableImageView!
    @IBOutlet weak var moreBtn: AnimatableButton!
    @IBOutlet weak var likeIcon: AnimatableImageView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentLbl: UILabel!
    
    var likeRef : Firebase!
    var postRef : Firebase!
    var post : Post!
    var user : User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeIcon.addGestureRecognizer(tap)
        likeIcon.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(post : Post){
        self.post = post
         self.setUserProfile()
        
            likeRef = DataService.instance.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        postRef = DataService.instance.REF_USER_CURRENT.childByAppendingPath("posts").childByAppendingPath(post.postKey)
            dispatch_async(dispatch_get_main_queue()) {
                self.postDescriptionLbl.text = post.postDescription
                self.likeLbl.text = "\(post.likes)"
                self.publishTimeLbl.text = NSDate().timeConverter(self.post.timeStamp, numericDates: true)
              
            }
            mainImageView.kf_showIndicatorWhenLoading = true
            if let mainImageUrl = NSURL(string: post.imageUrl) {
                mainImageView.kf_setImageWithURL(mainImageUrl, placeholderImage: nil,
                                                 optionsInfo: [.Transition(ImageTransition.Fade(1))],
                                                 progressBlock: { receivedSize, totalSize in},
                                                 completionHandler: { image, error, cacheType, imageURL in})
            }
            
            
            
            likeRef.observeSingleEventOfType(.Value) { (snapshot : FDataSnapshot!) in
                if (snapshot.value as? NSNull) != nil {
                    self.likeIcon.image = UIImage(named: "icon-upvote")
                }else {
                    self.likeIcon.image = UIImage(named: "icon-upvote-active")
                }
                
                
            }

        
        
    }
    func likeTapped(sender : UIGestureRecognizer){
        self.likeIcon.fadeOutIn()
        likeRef.observeSingleEventOfType(.Value) { (snapshot : FDataSnapshot!) in
            if (snapshot.value as? NSNull) != nil {
                self.likeIcon.image = UIImage(named: "icon-upvote-active")
                self.post.adjustLike(true)
                
                self.likeRef.setValue(true)
                
            }else {
                self.likeIcon.image = UIImage(named: "icon-upvote")
                self.post.adjustLike(false)
                self.likeRef.removeValue()
            }
        }
    }
    func setUserProfile() {
        
        DataService.instance.REF_USER.childByAppendingPath(self.post.userId).observeEventType(.Value, withBlock: { (snapshot) in
            if let user = snapshot.value as? Dictionary<String, AnyObject> {
                
                self.user = User(email: user["email"] as! String, profileImage: user["profileImageUrl"] as! String, username: user["username"] as! String,posts : user["posts"] as? Dictionary<String,Bool>)
                self.profileImageView.kf_showIndicatorWhenLoading = true
                
                if let profileImageUrl = NSURL(string: self.user.profileImage) {
                    self.profileImageView.kf_setImageWithURL(profileImageUrl, placeholderImage: nil,
                        optionsInfo: [.Transition(ImageTransition.Fade(1))],
                        progressBlock: { receivedSize, totalSize in},
                        completionHandler: { image, error, cacheType, imageURL in})
                }
                
                
                self.usernameLbl.text = self.user.username
            }
        })
    }
    
    @IBAction func more(sender : AnyObject) {
        let actionSheet = UIAlertController(title: "Share", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default, handler: { (action) in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                // Initialize the default view controller for sharing the post.
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC.setInitialText(self.post.postDescription)
                facebookComposeVC.addImage(self.mainImageView.image)
                UIApplication.sharedApplication().keyWindow?.currentViewController!.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                 KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.Black, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "Login first!")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default, handler: { (action) in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                // Initialize the default view controller for sharing the post.
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
               twitterComposeVC.setInitialText(self.post.postDescription)
                twitterComposeVC.addImage(self.mainImageView.image)
                 UIApplication.sharedApplication().keyWindow?.currentViewController!.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
               KRProgressHUD.showError(progressHUDStyle: KRProgressHUDStyle.Black, maskType: KRProgressHUDMaskType.Black, activityIndicatorStyle: KRProgressHUDActivityIndicatorStyle.Black, font: ERROR_ALERT_FONT, message: "Login first!")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
        }))
        postRef.observeSingleEventOfType(.Value) { (snapshot : FDataSnapshot!) in
            if (snapshot.value as? NSNull) != nil {
                
            }else {
                actionSheet.title = "Share or Configure"
                actionSheet.addAction(UIAlertAction(title: "Edit this post", style: UIAlertActionStyle.Default, handler: { (action) in
                    let alert = UIAlertController(title: "Edit your post", message: "Enter post description", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addTextFieldWithConfigurationHandler({ (textField) in
                        textField.placeholder = "Post desc."
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (_) in
                        let newDescription = alert.textFields![0].text!
                        let post = ["imageUrl" : self.post.imageUrl, "likes" : self.post.likes ,"postDescription" : newDescription,"user" : NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID)!,"timeStamp" : self.post.timeStamp]
                        DataService.instance.REF_POST.childByAppendingPath(self.post.postKey).updateChildValues(post)
                       
                    }))
                    
                     UIApplication.sharedApplication().keyWindow?.currentViewController!.presentViewController(alert, animated: true, completion: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Delete this post", style: UIAlertActionStyle.Destructive, handler: { (action) in
                  DataService.instance.REF_POST.childByAppendingPath(self.post.postKey).removeValue()
                }))

            }
            
            
        }
        
        UIApplication.sharedApplication().keyWindow?.currentViewController!.presentViewController(actionSheet, animated: true, completion: nil)

    }
}
