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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post : Post){
        
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
        
    
    }
   

}
