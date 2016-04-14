//
//  TestPeriod.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
@testable import ColorgyCourse
import Quick
import Nimble
import SwiftyJSON

class TestPeriod: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testCreatePeriod() {
		
		var period = Period(day: 0, period: 0, location: "locationnnn")
		expect(period).toNot(beNil())
		
		period = Period(day: -1, period: 0, location: "locationnnn")
		expect(period).to(beNil())
		
		period = Period(day: 7, period: 0, location: "locationnnn")
		expect(period).to(beNil())
	}
	
	func testCreatePeriodArray() {
		
		let days: [Int?] = [1,2,3,4]
		let periods: [Int?] = [1,2,3,3]
		let locations: [String?] = ["", "", "", ""]
		
		var array = Period.generatePeriods(days, periods: periods, locations: locations)
		expect(array.count).to(equal(4))
		
		array = Period.generatePeriods([1,1], periods: [1,2], locations: [nil, ""])
		expect(array.count).to(equal(2))
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
