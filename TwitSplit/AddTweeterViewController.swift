//
//  AddTweeterViewController.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit

protocol AddTweeterViewControllerDelegate {
    func tweeterViewController(_ controller: AddTweeterViewController, didSaveNewTweet tweet: String)
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
        delegate?.tweeterViewController(self, didSaveNewTweet: textView.text)
        navigationController?.popViewController(animated: true)
    }
}
