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
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var commentLbl: UILabel!
    
    var likeRef : Firebase!
    var post : Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: Selector("likeTapped:"))
        tap.numberOfTapsRequired = 1
        likeIcon.addGestureRecognizer(tap)
        likeIcon.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post : Post){
        self.post = post
        likeRef = DataService.instance.REF_CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        dispatch_async(dispatch_get_main_queue()) {
            self.postDescriptionLbl.text = post.postDescription
            self.likeLbl.text = "\(post.likes)"

        }
        mainImageView.kf_showIndicatorWhenLoading = true
        //profileImageView.kf_showIndicatorWhenLoading = true
        
        if let mainImageUrl = NSURL(string: post.imageUrl) {
            mainImageView.kf_setImageWithURL(mainImageUrl, placeholderImage: nil,
                                             optionsInfo: [.Transition(ImageTransition.Fade(1))],
                                             progressBlock: { receivedSize, totalSize in},
                                             completionHandler: { image, error, cacheType, imageURL in})
        }
        
        
        
        likeRef.observeSingleEventOfType(.Value) { (snapshot : FDataSnapshot!) in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeIcon.image = UIImage(named: "icon-upvote")
            }else {
                self.likeIcon.image = UIImage(named: "icon-upvote-active")
            }
        }

    }
    func likeTapped(sender : UIGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value) { (snapshot : FDataSnapshot!) in
            if let doesNotExist = snapshot.value as? NSNull {
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

}
