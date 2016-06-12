//
//  DataService.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Kingfisher

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
    var REF_USER_CURRENT: Firebase {
        if let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
            let user = Firebase(url: "\(REF_USER)").childByAppendingPath(uid)
            return user!
        } else {
            return Firebase()
        }
    }
 
    func createUser(uid : String ,user : Dictionary<String, AnyObject>){
        _REF_USER.childByAppendingPath(uid).setValue(user)
    }
    
    func getUserData(userId : String, completion : (user : User)->()) {
        
        DataService.instance.REF_USER.childByAppendingPath(userId).observeEventType(.Value, withBlock: { (snapshot) in
            if let user = snapshot.value as? Dictionary<String, AnyObject> {
                
                let user = User(email: user["email"] as! String, profileImage: user["profileImageUrl"] as! String, username: user["username"] as! String)
                completion(user: user)
            }
        })
    }
    
 
}