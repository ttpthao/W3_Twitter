//
//  HomeViewController.swift
//  W3_Twitter
//
//  Created by Phuong Thao Tran on 3/3/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tweetsTable: UITableView!
    
    var tweets = [Tweet]()
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var currentPageCount: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetsTable.estimatedRowHeight = 100
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        self.tweetsTable.delegate = self
        self.tweetsTable.dataSource = self
        
        fetchData(count: 20)
        pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(count: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.fetchData), for: UIControlEvents.valueChanged)
        self.tweetsTable.addSubview(refreshControl)
    }
    
    func fetchData(count: Int) {
        refreshControl.beginRefreshing()
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets.removeAll()
            self.tweets.append(contentsOf: tweets)
            
            self.tweetsTable.reloadData()
            self.refreshControl.endRefreshing()
            self.isMoreDataLoading = false
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
            self.refreshControl.endRefreshing()
        }, count: count)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = self.tweetsTable.contentSize.height
            let scrollOffset = scrollViewContentHeight - self.tweetsTable.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffset && self.tweetsTable.isDragging) {
                isMoreDataLoading = true
                currentPageCount += 20
                refreshControl.beginRefreshing()
                fetchData(count: currentPageCount)
            }
        }
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }

    @IBAction func onCompose(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "composeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsSegue" {
//            let indexPath = self.tweetsTable.indexPathForSelectedRow?.row
//            if let detailsVc = segue.destination as? DetailsViewController{
//                detailsVc.tweet = tweets[indexPath!]
//                print(tweets[indexPath!])
//            }
//        }
        let navigationController = segue.destination as! UINavigationController
        if navigationController.topViewController is DetailsViewController {
            let detailViewController = navigationController.topViewController as! DetailsViewController
            //detailViewController.delegate = self
            
            var indexPath: AnyObject!
            indexPath = tweetsTable.indexPath(for: sender as! UITableViewCell) as AnyObject!
            
            detailViewController.tweet = tweets[indexPath!.row]
            detailViewController.indexPath = indexPath! as? NSIndexPath
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTable.dequeueReusableCell(withIdentifier: "tweetsCell") as! TweetsCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
}
