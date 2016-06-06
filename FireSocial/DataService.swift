//
//  DataService.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://fire-social.firebaseio.com"
class DataService {
    private var _REF_BASE : Firebase = Firebase(url: "\(BASE_URL)")
    private var _REF_USER : Firebase = Firebase(url: "\(BASE_URL)/users")
    private var _REF_POST : Firebase = Firebase(url: "\(BASE_URL)/posts")
    static let instance = DataService()
    
    var REF_BASE : Firebase {
        return _REF_BASE
    }
    var REF_USER : Firebase {
        return _REF_USER
    }
    var REF_POST : Firebase {
        return _REF_POST
    }
    var REF_CURRENT_USER : Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    func createUser(uid : String ,user : Dictionary<String, AnyObject>){
        _REF_USER.childByAppendingPath(uid).setValue(user)
    }
    
 
}