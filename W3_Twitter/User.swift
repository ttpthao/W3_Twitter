//
//  User.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/3/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit

let currentUserKey = "currentUser"
let currentUserDataKey = "currentUserData"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary
    
    static var _currentUser: User?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageURLString = dictionary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            profileImageUrl = URL(string: profileImageURLString)!
        }
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.data(forKey: currentUserDataKey)
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                
                defaults.set(data, forKey: currentUserKey)
                
            } else {
                defaults.set(nil, forKey: currentUserKey)
            }
            defaults.synchronize()
        }
    }
    
    //    static var currentUser: User? {
    //        get {
    //            if self.currentUser == nil {
    //                let data = UserDefaults.standard.data(forKey: "currentuser")
    //                if let data = data  {
    //                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
    //                    self.currentUser = User(dictionary: dictionary)
    //                }
    //            }
    //            return self.currentUser
    //        }
    //
    //        set(user) {
    //            self.currentUser = user
    //            if self.currentUser != nil {
    //                let data = try! JSONSerialization.data(withJSONObject: user!.dictionary, options: JSONSerialization.WritingOptions())
    //                UserDefaults.standard.set(data, forKey: "currentuser")
    //            } else {
    //                UserDefaults.standard.set(nil, forKey: "currentuser")
    //            }
    //            UserDefaults.standard.synchronize()
    //        }
    //    }
}
