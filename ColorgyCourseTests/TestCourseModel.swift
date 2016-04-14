//
//  TestCourseModel.swift
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

class TestCourseModel: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testCreateCourse() {
		
		var code: String?
		var name: String?
		var year: Int?
		var term: Int?
		var lecturer: String?
		var credits: Int?
		var _type: String?
		var days: [Int?] = []
		var periods: [Int?] = []
		var locations: [String?] = []
		var general_code: String?
		
		var course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).to(beNil())
		
		code = "某某某"
		course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).to(beNil())
		
		name = "某節課"
		year = 2015
		term = 1
		course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).toNot(beNil())
		expect(course!.name).to(equal(name))
		expect(course!.year).to(equal(year))
		expect(course!.term).to(beLessThanOrEqualTo(2))
		expect(course!.term).to(equal(term))
		
		name = "某節課"
		year = 2015
		term = 3
		course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).to(beNil())
		
		term = 1
		days = [1,2,3]
		periods = [1,2,3,3]
		locations = ["qq","qq","qq"]
		
		course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).toNot(beNil())
		expect(course!.periods.count).to(equal(0))
		
		days = [1,2,3]
		periods = [1,2,3]
		locations = ["qq","qq","qq"]
		
		course = Course(code: code, name: name, year: year, term: term, lecturer: lecturer, credits: credits, _type: _type, days: days, periods: periods, locations: locations, general_code: general_code)
		
		expect(course).toNot(beNil())
		expect(course!.periods.count).to(equal(3))
	}
	
	func testGenerate() {
		let array = Course.generateCourseArrayWithRawDataObjects([])
		expect(array.count).to(equal(0))
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
