//
//  Post.swift
//  FireSocial
//
//  Created by yusuf_kildan on 06/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDescription : String!
    private var _imageUrl : String!
    private var _likes : Int!
    private var _username : String!
    private var _postKey : String!
    private var _postRef : Firebase!
    
    var postDescription : String {
        if _postDescription == nil {
            _postDescription = ""
        }
        return _postDescription
    }
    
    
    var imageUrl  :String {
        if _imageUrl == nil {
            _imageUrl = ""
        }
        return _imageUrl
    }
    
    var likes : Int {
        if _likes == nil {
            _likes = 0
        }
        return _likes
    }
    
    var username : String {
        if _username == nil {
            _username = ""
        }
        return _username
    }
    var postKey : String {
        return _postKey
    }

    init(description : String , imageUrl : String , username : String) {
        self._imageUrl = imageUrl
        self._postDescription = description
        self._username = username
    }
    
    init(postKey : String , dictionary : Dictionary<String , AnyObject>){
        self._postKey = postKey
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let description = dictionary["postDescription"] as? String {
            self._postDescription = description
        }
       _postRef = DataService.instance.REF_POST.childByAppendingPath(self.postKey)
    }
    
    func adjustLike(addLike : Bool){
        if addLike {
            _likes = _likes + 1
        }else {
            _likes = _likes - 1
        }
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }

}