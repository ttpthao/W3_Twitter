//
//  ComposeViewController.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/4/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    @objc optional func composeViewController(composeViewController: ComposeViewController,contentPosted content: String)
}

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var limit = 140
    let placeHolderText = "What's happening?"
    let blueColor = UIColor(red: 38, green: 178, blue: 253, alpha: 1.0)
    
    var newTweet: Tweet?
    
    var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.delegate = self
        tweetText.textColor = UIColor.gray
        tweetText.becomeFirstResponder()
        
        customizeTweetButton()
        customizeBarButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.onShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.onHideKeyBoard(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func customizeBarButton(){
        let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        avatar.setImageWith((User.currentUser?.profileImageUrl)!)
        
        let button: UIButton = UIButton()
        button.setImage(avatar.image, for: .normal)
        button.frame = CGRectMake(0, 0, 28, 28)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = button
        leftBarButtonItem.customView?.layer.cornerRadius = 11
        leftBarButtonItem.customView?.layer.masksToBounds = true
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func customizeTweetButton() {
        tweetButton.backgroundColor = UIColor(red: 82/255, green: 173/255, blue: 243/255, alpha: 1.0)
        tweetButton.tintColor = UIColor.white
        tweetButton.layer.cornerRadius = 5
        tweetButton.alpha = 0.7
        tweetButton.isEnabled = false
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.postTweet(status: tweetText.text!, success: {_ in 
            self.delegate?.composeViewController!(composeViewController: self, contentPosted: self.tweetText.text)
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error:Error) in
            print("\(error.localizedDescription)")
        })
    }
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if tweetText.text != placeHolderText && tweetText.text != "" {
            let countdownCharacter = limit - tweetText.text.characters.count
            limitLabel.text = "\(countdownCharacter)"
            if countdownCharacter < 20 {
                limitLabel.textColor = UIColor.red
            }
            else {
                limitLabel.textColor = UIColor.black
            }
            tweetButton.alpha = 1
            tweetButton.isEnabled = true
        }
    }
    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == tweetText && aTextView.text == placeHolderText
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async(execute: { 
            aTextView.selectedRange = NSMakeRange(0, 0)
        })
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        
        if newLength > 0 // have text, so don't show the placeholder
        {
            if newLength > limit {
                return false
            }
            // check if the only text is the placeholder and remove it if needed
            if textView == tweetText && textView.text == placeHolderText
            {
                applyNonPlaceholderStyle(aTextview: tweetText)
                tweetText.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: tweetText, placeholderText: placeHolderText)
            moveCursorToStart(aTextView: tweetText)
            return false
        }
    }
    
    func onShowKeyboard(_ notification: NSNotification){
        
        var userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.bottomConstraint.constant = keyboardFrame.size.height
    }
    
    func onHideKeyBoard(_ notification: NSNotification){
        self.bottomConstraint.constant = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tweetText.resignFirstResponder()
    }
    
}
