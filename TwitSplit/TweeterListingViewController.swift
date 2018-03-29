//
//  TweeterListingViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

class TweeterListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweeters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Simple trick to remove ugly fillers
        tableView.tableFooterView = UIView()
        
        //Enable dynamic row height
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Register cells
        tableView.register(TweeterViewCell.self)
        
        tweeters = ["Hey", "There"]
    }
    
    @IBAction func addTweeter(_ sender: Any) {
        let controller = UIStoryboard.main.controller(AddTweeterViewController.self)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TweeterListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweeters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TweeterViewCell.self, for: indexPath)
        cell.contentLabel.text = tweeters[indexPath.row]
        return cell
    }
}

extension TweeterListingViewController: AddTweeterViewControllerDelegate {
    
    func tweeterViewController(_ controller: AddTweeterViewController, didSaveNewTweet tweet: String) {
        //Newest tweet goes to top
        tweeters.insert(tweet, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
