//
//  TestTimeStamp.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
@testable import ColorgyCourse
import Quick
import Nimble

class TestTimeStamp: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let email = "colorgy-test-account-94@test.colorgy.io"
		let pass = "colorgy-test-account-94"
		ColorgyLogin.loginToColorgyWithEmail(email: email, password: pass, success: { (result) in
			expect(true).to(beTrue())
			}) { (error, afError) in
				XCTFail()
		}
		NSThread.sleepForTimeInterval(5.0)
    }
	
	func testAccessToken() {
		expect(ColorgyUserInformation.sharedInstance().userAccessToken).toNot(beNil())
	}
	
	func testTimeStampCreate() {
		let t1 = "2016-03-22T03:05:32.979Z"
		let t2 = "2016-04-07T16:39:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).toNot(beNil())
		expect(ts2).toNot(beNil())
		
		// ms
		let t1ms = "2016-03-22T03:05:32.9799Z"
		let t2ms = "2016-04-07T16:39:59.9Z"
		
		let ts1ms = TimeStamp(timeStampString: t1ms)
		let ts2ms = TimeStamp(timeStampString: t2ms)
		
		expect(ts1ms).toNot(beNil())
		expect(ts2ms).toNot(beNil())
		
		// sec
		let t1s = "2016-03-22T03:05:60.979Z"
		let t2s = "2016-04-07T16:39:0.979Z"
		
		let ts1s = TimeStamp(timeStampString: t1s)
		let ts2s = TimeStamp(timeStampString: t2s)
		
		expect(ts1s).to(beNil())
		expect(ts2s).toNot(beNil())
		
		// min
		let t1min = "2016-03-22T03:60:32.979Z"
		let t2min = "2016-04-07T16:001:59.521Z"
		
		let ts1min = TimeStamp(timeStampString: t1min)
		let ts2min = TimeStamp(timeStampString: t2min)
		
		expect(ts1min).to(beNil())
		expect(ts2min).toNot(beNil())
		
		// hour
		let t1h = "2016-03-22T24:05:32.979Z"
		let t2h = "2016-04-07T016:39:59.521Z"
		
		let ts1h = TimeStamp(timeStampString: t1h)
		let ts2h = TimeStamp(timeStampString: t2h)
		
		expect(ts1h).to(beNil())
		expect(ts2h).toNot(beNil())
		
		// date
		let t2d = "2016-03-31T03:05:32.979Z"
		let t1d = "2016-04-32T16:39:59.521Z"
		
		let ts1d = TimeStamp(timeStampString: t1d)
		let ts2d = TimeStamp(timeStampString: t2d)
		
		expect(ts1d).to(beNil())
		expect(ts2d).toNot(beNil())
		
		// month
		let t2m = "2016-03-22T03:05:32.979Z"
		let t1m = "2016-00-07T16:39:59.521Z"
		
		let ts1m = TimeStamp(timeStampString: t1m)
		let ts2m = TimeStamp(timeStampString: t2m)
		
		expect(ts1m).to(beNil())
		expect(ts2m).toNot(beNil())
		
		// year
		let t1y = "1969-03-22T03:05:32.979Z"
		let t2y = "2099-04-07T16:39:59.521Z"
		
		let ts1y = TimeStamp(timeStampString: t1y)
		let ts2y = TimeStamp(timeStampString: t2y)
		
		expect(ts1y).to(beNil())
		expect(ts2y).toNot(beNil())
		
		// nil
		let ts1n = TimeStamp(timeStampString: "o-03-22T03:05:32.979Z")
		let ts2n = TimeStamp(timeStampString: "1969-o-22T03:05:32.979Z")
		let ts3n = TimeStamp(timeStampString: "1969-03-oT03:05:32.979Z")
		let ts4n = TimeStamp(timeStampString: "1969-03-22To:05:32.979Z")
		let ts5n = TimeStamp(timeStampString: "1969-03-22T03:o:32.979Z")
		let ts6n = TimeStamp(timeStampString: "1969-03-22T03:05:xZ")
		
		expect(ts1n).to(beNil())
		expect(ts2n).to(beNil())
		expect(ts3n).to(beNil())
		expect(ts4n).to(beNil())
		expect(ts5n).to(beNil())
		expect(ts6n).to(beNil())
	}
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
