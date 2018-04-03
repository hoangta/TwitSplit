//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import XCTest
@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMessageSplitting() {
        //Case 1
        var tweets1: [Tweet]?
        do {
            tweets1 = try Tweet.makeTweets(from: "Thisisaverylonglonglongboringtextwithoutanyseparators")
        }
        catch MakeTweetError.nonsenseTweet {
            print("Your tweet contains a bunch of nonsense, please check again.")
        }
        catch {
            print("Unexpected error: \(error).")
        }
        
        XCTAssertNil(tweets1)
        
        //Case 2
        let tweets2 = try! Tweet.makeTweets(from: "This is a very long long long boring text without any separators")
        print(tweets2)
        XCTAssertTrue(tweets2.count == 2)
        
        //Case 2
        let tweets3 = try! Tweet.makeTweets(from: "This is a very long long long boring text without any separators, hopefully long enough to make it to 3 parts")
        print(tweets3)
        XCTAssertTrue(tweets3.count == 3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
