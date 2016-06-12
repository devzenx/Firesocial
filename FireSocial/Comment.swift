//
//  Comment.swift
//  FireSocial
//
//  Created by yusuf_kildan on 10/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
class Comment {

    private var _commentText : String!
    private var _timeStamp : String!
    private var _userId : String!
    private var _postId : String!
    
    var commentText : String {
        if _commentText == nil {
            _commentText = ""
        }
        return _commentText
    }
    
    var timeStamp : String {
        if _timeStamp == nil {
            _timeStamp = ""
        }
        return _timeStamp
    }
    
    var userId : String {
        if _userId == nil {
            _userId = ""
        }
        return _userId
    }
    var postId : String {
        return _postId
    }
    
    init(userId : String ,dictionary : Dictionary<String,AnyObject>) {
       _userId = userId
        if let commentText = dictionary["commentText"] as? String {
            self._commentText = commentText
            print(commentText)
        }
        
        if let timeStamp = dictionary["timeStamp"] as? String {
            self._timeStamp = timeStamp
             print(timeStamp)
        }
    }
    
    


}