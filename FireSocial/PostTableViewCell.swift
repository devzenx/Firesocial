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
            dispatch_async(dispatch_get_main_queue()) {
                self.postDescriptionLbl.text = post.postDescription
                self.likeLbl.text = "\(post.likes)"
                self.publishTimeLbl.text = NSDate().timeConverter(self.post.timeStamp, numericDates: false)
               print(self.post.timeStamp)
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
    

}
