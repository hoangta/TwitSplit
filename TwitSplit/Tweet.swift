//
//  Tweet.swift
//  TwitSplit
//
//  Created by Hoang Ta on 4/3/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import Foundation

struct Tweet {
    let content: String
    
    init(_ content: String) {
        self.content = content
    }
}

enum MakeTweetError: Error {
    case invisibleCharacters, nonsenseTweet
}

//Tweet factory
extension Tweet {
    
    static func makeTweets(from text: String, estimatedNumberOfParts: Int? = nil) throws -> [Tweet] {
        //We don't want the empty tweet
        guard text.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else {
            throw MakeTweetError.invisibleCharacters
        }
        
        //Check if the tweet need more process for being chunky
        //Further note: I used guard to return unwanted result, if the one is expected, use 'if' if neccessary
        if text.count <= 50 {
            return [Tweet(text)]
        }
        
        let maxLengthPerTweet = 50
        let estimatedNumberOfParts = estimatedNumberOfParts ?? text.count/maxLengthPerTweet + 1 //Combined with the part indicator, +1 is always valid here
        var parts = ["1/\(estimatedNumberOfParts)"]
        for word in text.components(separatedBy: .whitespacesAndNewlines) {
            let tempPart = parts[parts.count - 1] + " " + word
            //Check valid tweet
            if tempPart.count <= 50 {
                parts[parts.count - 1] = tempPart
                continue
            }
            
            //Check if the new indicator is greater than the estimated
            if parts.count + 1 > estimatedNumberOfParts {
                return try makeTweets(from: text, estimatedNumberOfParts: estimatedNumberOfParts + 1)
            }
            
            //Add new part
            let newPart = "\(parts.count + 1)/\(estimatedNumberOfParts) \(word)"
            if newPart.count > maxLengthPerTweet {
                throw MakeTweetError.nonsenseTweet
            }
            parts.append(newPart)
        }
        return parts.map { Tweet($0) }
    }
}
