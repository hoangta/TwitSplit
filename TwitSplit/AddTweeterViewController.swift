//
//  AddTweeterViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

protocol AddTweeterViewControllerDelegate {
    func tweeterViewController(_ controller: AddTweeterViewController, didSaveNewTweets tweets: [String])
}

class AddTweeterViewController: UIViewController {

    var delegate: AddTweeterViewControllerDelegate?
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Barbuttons
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTweeter))
        saveButton.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc private func saveTweeter() {
        //Sanity check
        guard let tweet = textView.text else {
            return
        }
        
        //We don't want the empty tweet
        guard tweet.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else {
            return
        }
                
        //Check if the tweet need more process for being chunky
        if tweet.count <= 50 {
            delegate?.tweeterViewController(self, didSaveNewTweets: [textView.text])
            navigationController?.popViewController(animated: true)
            return
        }
        
        //Chunky tweet logic starts here...
        do {
            let parts = try splitMessage(tweet)
            delegate?.tweeterViewController(self, didSaveNewTweets: parts)
            navigationController?.popViewController(animated: true)
        }
        catch SplitMessageError.longAndNoSpaceTweet {
            print("No, just no..")
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    enum SplitMessageError: Error {
        case longAndNoSpaceTweet
    }
    
    private func splitMessage(_ tweet: String, estimatedNumberOfParts: Int? = nil) throws -> [String] {
        let estimatedNumberOfParts = estimatedNumberOfParts ?? tweet.count/50 + 1 //Combined with the part indicator, +1 is always valid here
        var parts = ["1/\(estimatedNumberOfParts)"]
        for word in tweet.components(separatedBy: .whitespacesAndNewlines) {
            let tempPart = parts[parts.count - 1] + " " + word
            //Check valid tweet
            if tempPart.count <= 50 {
                parts[parts.count - 1] = tempPart
                continue
            }
            
            //Check if the new indicator is greater than the estimated
            if parts.count + 1 > estimatedNumberOfParts {
                return try splitMessage(tweet, estimatedNumberOfParts: estimatedNumberOfParts + 1)
            }
            
            //Add new part
            let newPart = "\(parts.count + 1)/\(estimatedNumberOfParts) \(word)"
            if newPart.count > 50 {
                throw SplitMessageError.longAndNoSpaceTweet
            }
            parts.append(newPart)
        }
        return parts
    }
}
