//
//  AddTweeterViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

protocol AddTweetViewControllerDelegate {
    func tweetViewController(_ controller: AddTweetViewController, didSaveNewTweets tweets: [String])
}

class AddTweetViewController: UIViewController {

    var delegate: AddTweetViewControllerDelegate?
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
            showAlert("Are those spaces supposed to be invisible characters?")
            return
        }
                
        //Check if the tweet need more process for being chunky
        //Further note: I used guard to return unwanted result, if the one is expected, use 'if' if neccessary
        if tweet.count <= 50 {
            delegate?.tweetViewController(self, didSaveNewTweets: [textView.text])
            navigationController?.popViewController(animated: true)
            return
        }
        
        //Chunky tweet logic starts here...
        do {
            let parts = try splitMessage(tweet)
            delegate?.tweetViewController(self, didSaveNewTweets: parts)
            navigationController?.popViewController(animated: true)
        }
        catch SplitMessageError.longAndNoSpaceTweet {
            showAlert("Your tweet contains a bunch of nonsense, please check again.")
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    private func showAlert(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

enum SplitMessageError: Error {
    case longAndNoSpaceTweet
}

func splitMessage(_ tweet: String, maxLengthPerMessage: Int = 50, estimatedNumberOfParts: Int? = nil) throws -> [String] {
    let estimatedNumberOfParts = estimatedNumberOfParts ?? tweet.count/maxLengthPerMessage + 1 //Combined with the part indicator, +1 is always valid here
    var parts = ["1/\(estimatedNumberOfParts)"]
    for word in tweet.components(separatedBy: .whitespacesAndNewlines) {
        let tempPart = parts[parts.count - 1] + " " + word
        //Check valid tweet
        if tempPart.count <= maxLengthPerMessage {
            parts[parts.count - 1] = tempPart
            continue
        }
        
        //Check if the new indicator is greater than the estimated
        if parts.count + 1 > estimatedNumberOfParts {
            return try splitMessage(tweet, estimatedNumberOfParts: estimatedNumberOfParts + 1)
        }
        
        //Add new part
        let newPart = "\(parts.count + 1)/\(estimatedNumberOfParts) \(word)"
        if newPart.count > maxLengthPerMessage {
            throw SplitMessageError.longAndNoSpaceTweet
        }
        parts.append(newPart)
    }
    return parts
}
