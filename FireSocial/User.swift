//
//  User.swift
//  FireSocial
//
//  Created by yusuf_kildan on 07/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation

class User {
    private var _username: String!
    private var _profileImageUrl: String!
    private var _email: String!
    
    var username: String {
        if _username == nil {
            _username = ""
        }
        return _username
    }
    
    var profileImgUrl: String {
        return _profileImageUrl
    }
    var email : String {
        return _email 
    }
    
    init(dic : Dictionary<String,AnyObject>){
        if let username = dic["username"] as? String {
            self._username = username
        }
        
        if let profileImageUrl = dic["profileImageUrl"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        
        
        if let email = dic["email"] as? String {
            self._email = email
        }

    }

}