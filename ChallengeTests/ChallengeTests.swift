//
//  ChallengeTests.swift
//  ChallengeTests
//
//  Created by Renan on 09/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import XCTest
@testable import Challenge

class ChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPosts() {
        let expectation = self.expectation(description: "posts")
        Post().getPostsFromServer { (p, error) in
            if p!.count > 0 {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testComments() {
        let expectation = self.expectation(description: "comments")
        Comments().getCommentsFromServer(postId: 1, completion: { (c, error) in
            XCTAssert(c!.count > 0, "Success")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUser() {
        let expectation = self.expectation(description: "user")
        User().getUserInfoFromServer(userId: 1) { (user, error) in
            XCTAssert(user?.userName == "Bret", "Success")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
