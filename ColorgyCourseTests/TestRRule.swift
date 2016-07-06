//
//  TestRRule.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/6.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
@testable import ColorgyCourse
import Quick
import Nimble

class TestRRule: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testSameDateAndAllOcurrences() {
		let rs = "DTSTART=20150901T000000Z;UNTIL=20160131T000000Z;FREQ=WEEKLY;WKST=MO;"
		let rs2 = "DTSTART=20150831T231407Z;UNTIL=20150901T231408Z;FREQ=WEEKLY;INTERVAL=1;WKST=MO;"
		let rr = RRule(initWithRRuleString: rs2)
		expect(rr).toNot(beNil())
		if let rr = rr {
			expect(rr.allOccurrences().count).to(equal(0))
		}
		print(rr?.allOccurrences())
	}
	
	func testOccurences() {
		let before = NSDate.create(dateOnYear: 2015, month: 8, day: 31, hour: 0, minute: 0, second: 0)
		let after = NSDate.create(dateOnYear: 2015, month: 9, day: 31, hour: 0, minute: 0, second: 0)
		expect(before!).toNot(beNil())
		expect(after!).toNot(beNil())
		let rr = RRule(withStartDate: before!, until: after!)
		expect(rr.dtStart.rruleFormatString).to(equal("20150830T160000Z"))
		expect(rr.until.rruleFormatString).to(equal("20150930T160000Z"))
	}
	
	func testRRuleStringConverting() {
		let before = NSDate.create(dateOnYear: 2015, month: 8, day: 31, hour: 0, minute: 0, second: 0)
		let after = NSDate.create(dateOnYear: 2015, month: 9, day: 31, hour: 0, minute: 0, second: 0)
		expect(before!).toNot(beNil())
		expect(after!).toNot(beNil())
		let rr = RRule(withStartDate: before!, until: after!)
	}
		
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
