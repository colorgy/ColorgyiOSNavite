//
//  CourseListGenerator.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class CourseListGenerator: GeneratorType {
	public typealias Element = Course
	
	var currentIndex: Int = 0
	var courseList: [Course]?
	
	init(courseList: [Course]) {
		self.courseList = courseList
	}
	
	public func next() -> Element? {
		guard let list = courseList else { return nil }
		
		if currentIndex < list.count {
			let element = list[currentIndex]
			currentIndex += 1
			return element
		} else {
			return nil
		}
	}
}