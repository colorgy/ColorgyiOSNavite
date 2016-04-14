//
//  TestColorgyAPI.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import XCTest
@testable import ColorgyCourse
import Quick
import Nimble

class TestColorgyAPI: XCTestCase {
	
	var colorgyAPI: ColorgyAPI!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		colorgyAPI = ColorgyAPI()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testMeApi() {
		
	}
	
	func testGetCourseFromServer() {
		
		var courses = [Course]()
		let courseCount = 10
		
		func done() {
			expect(courses.count).to(equal(courseCount))
		}
		
		waitUntil(timeout: 30.0) { (done) in
			ColorgyAPI().getSchoolCourseData(courseCount, year: 2015, term: 1, success: { (_courses) in
				for c in _courses {
					courses.append(c)
				}
				done()
			}, process: nil) { (error, afError) in
				XCTFail()
			}
		}
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
