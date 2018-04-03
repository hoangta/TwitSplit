//
//  TweeterListingViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

class TweetListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Simple trick to remove ugly fillers
        tableView.tableFooterView = UIView()
        
        //Enable dynamic row height
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Register cells
        tableView.register(TweetViewCell.self)
        
        tweets = ["Hey", "There"]
    }
    
    @IBAction func addTweeter(_ sender: Any) {
        let controller = UIStoryboard.main.controller(AddTweetViewController.self)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TweetListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TweetViewCell.self, for: indexPath)
        cell.contentLabel.text = tweets[indexPath.row]
        return cell
    }
}

extension TweetListingViewController: AddTweetViewControllerDelegate {
    func tweetViewController(_ controller: AddTweetViewController, didSaveNewTweets tweets: [String]) {
        //Newest tweet goes to top
        self.tweets = tweets + self.tweets
        tableView.insertRows(at: tweets.enumerated().map { IndexPath(row: $0.offset, section: 0) }, with: .automatic)
    }
}
