//
//  AddTweeterViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

protocol AddTweetViewControllerDelegate {
    func tweetViewController(_ controller: AddTweetViewController, didSaveNewTweets tweets: [Tweet])
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
        guard let text = textView.text else {
            return
        }
        
        //Chunky tweet logic starts here...
        do {
            let tweets = try Tweet.makeTweets(from: text)
            delegate?.tweetViewController(self, didSaveNewTweets: tweets)
            navigationController?.popViewController(animated: true)
        }
        catch MakeTweetError.invisibleCharacters {
            showAlert("Are those spaces supposed to be invisible characters?")
        }
        catch MakeTweetError.nonsenseTweet {
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


