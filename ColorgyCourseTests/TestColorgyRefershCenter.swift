//
//  TestColorgyRefershCenter.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
@testable import ColorgyCourse
import Quick
import Nimble

class TestColorgyRefershCenter: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		ColorgyRefreshCenter.initialization()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testTokenState() {
		expect(ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState).toNot(equal(RefreshTokenState.Revoke))
	}
	
	func testDoesHaveToken() {
		
		// Make sure these are not nil
		expect(ColorgyRefreshCenter.sharedInstance().accessToken).toNot(equal(nil))
		expect(ColorgyRefreshCenter.sharedInstance().refreshToken).toNot(equal(nil))
	}
	
	func testRefreshingTokenRemainingTime() {
		
		let remainigTime = ColorgyRefreshCenter.refreshTokenRemainingTime()
		
		if remainigTime.remainingTime > 0 {
			expect(remainigTime.currentState).to(equal(RefreshTokenState.Active))
		}
	}
	
	func testRefreshingToken() {
		
		func done() {
			expect(ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState).to(equal(RefreshTokenState.Active))
		}
		
		waitUntil(timeout: 30.0) { (done) in
			ColorgyRefreshCenter.refreshAccessToken(success: {
				done()
				}, failure: nil)
		}
	}
	
	func testGettingRefreshingState() {
		
		func done() {
			expect(ColorgyRefreshCenter.sharedInstance().currentRefreshTokenState).to(equal(RefreshTokenState.Active))
		}
		
		waitUntil { (done) in
			ColorgyRefreshCenter.retryUntilTokenIsAvailable()
			NSThread.sleepForTimeInterval(0.5)
			done()
		}
	}

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
