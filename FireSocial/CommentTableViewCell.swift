//
//  CommentTableViewCell.swift
//  FireSocial
//
//  Created by yusuf_kildan on 10/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var commentLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var usernameLbl : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var comment : Comment!
    var users = [User]()

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
    }
    func configureCell(comment : Comment) {
        
        dispatch_async(dispatch_get_main_queue()){
            self.commentLbl.text = comment.commentText
            self.timeLbl.text = NSDate().timeConverter(comment.timeStamp, numericDates: true)
            
            
        }
        DataService.instance.getUserData(comment.userId) { (user) in
            if let mainImageUrl = NSURL(string: user.profileImage) {
                self.profileImage.kf_showIndicatorWhenLoading = true
                self.profileImage.kf_setImageWithURL(mainImageUrl, placeholderImage: nil,
                                                         optionsInfo: [.Transition(ImageTransition.Fade(1))],
                                                         progressBlock: { receivedSize, totalSize in},
                                                         completionHandler: { image, error, cacheType, imageURL in})
            }
            self.usernameLbl.text = user.username
        }
    
    }
    
    


}
