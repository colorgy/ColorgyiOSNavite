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
	}
	
	func testTimeStampMillisecond() {
		let t1 = "2016-03-22T03:05:32.9799Z"
		let t2 = "2016-04-07T16:39:59.9Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).toNot(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampSecond() {
		let t1 = "2016-03-22T03:05:60.979Z"
		let t2 = "2016-04-07T16:39:0.979Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampMinute() {
		let t1 = "2016-03-22T03:60:32.979Z"
		let t2 = "2016-04-07T16:001:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampHour() {
		let t1 = "2016-03-22T24:05:32.979Z"
		let t2 = "2016-04-07T016:39:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampDate() {
		let t2 = "2016-03-31T03:05:32.979Z"
		let t1 = "2016-04-32T16:39:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampMonth() {
		let t2 = "2016-03-22T03:05:32.979Z"
		let t1 = "2016-00-07T16:39:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testTimeStampYear() {
		let t1 = "1969-03-22T03:05:32.979Z"
		let t2 = "2099-04-07T16:39:59.521Z"
		
		let ts1 = TimeStamp(timeStampString: t1)
		let ts2 = TimeStamp(timeStampString: t2)
		
		expect(ts1).to(beNil())
		expect(ts2).toNot(beNil())
	}
	
	func testNilValueOnCreatingTimeStamp() {
		let ts1 = TimeStamp(timeStampString: "o-03-22T03:05:32.979Z")
		let ts2 = TimeStamp(timeStampString: "1969-o-22T03:05:32.979Z")
		let ts3 = TimeStamp(timeStampString: "1969-03-oT03:05:32.979Z")
		let ts4 = TimeStamp(timeStampString: "1969-03-22To:05:32.979Z")
		let ts5 = TimeStamp(timeStampString: "1969-03-22T03:o:32.979Z")
		let ts6 = TimeStamp(timeStampString: "1969-03-22T03:05:xZ")
		
		expect(ts1).to(beNil())
		expect(ts2).to(beNil())
		expect(ts3).to(beNil())
		expect(ts4).to(beNil())
		expect(ts5).to(beNil())
		expect(ts6).to(beNil())
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
