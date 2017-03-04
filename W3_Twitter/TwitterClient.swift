//
//  TwitterClient.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/3/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "MswOaPYH6zAiUxBLPgYVkZcho"
let consumerSecret = "fn3hvzstbT4X4P6sfMa8TSB0Pceyn7iegbaMLv8PsqCeLBbeYO"

class TwitterClient: BDBOAuth1SessionManager {
    static var sharedInstance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func authenticate(success: @escaping ()->(), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "ttpthaotwitter://oauth"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            
            if let response = response {
                print(response.token)
                
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                
                UIApplication.shared.openURL(authURL!)
            }
            
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.loginFailure!(error!)
        })
    }
    
    func handleOpenUrl(url: NSURL? ){
        let requestToken = BDBOAuth1Credential(queryString: url?.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            self.getUserInfo(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }) { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func getUserInfo(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        _ = get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                print(user.name!)
                print(user.screenName!)
                print(user.profileImageUrl!)
                
                success(user)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> () , failure: @escaping (Error?) -> () , count : Int ){
        get("1.1/statuses/home_timeline.json", parameters: ["count":"\(count)"], progress: nil, success: { (task:URLSessionDataTask,response: Any?) in
            print("Get home data success")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
        }, failure: { (task:URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
}
