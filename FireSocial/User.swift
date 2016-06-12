//
//  User.swift
//  FireSocial
//
//  Created by yusuf_kildan on 07/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation


class User {
    private var _username : String!
    private var _profileImage : String!
    private var _email : String!
    
    var username : String {
        if _username == nil {
            _username = ""
        }
        return _username
    }
    
    var profileImage: String {
        if _profileImage == nil {
            _profileImage = ""
        }
        return _profileImage
    }
    
    init(email: String, profileImage: String, username: String) {
        self._username = username
        self._profileImage = profileImage
        self._email = email
    }
}