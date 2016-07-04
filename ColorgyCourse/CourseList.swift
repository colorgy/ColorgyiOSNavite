//
//  CourseList.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

final public class CourseList {
	public var courseList: [Course]
	
	public init() {
		courseList = [Course]()
	}
	
	public func add(course: Course) {
		courseList.append(course)
	}
	
	// MARK: - Getter
	public var count: Int {
		return courseList.count
	}
	
	// MARK: - Subscript
	public subscript(index: Int) -> Course {
		
		get {
			return courseList[index]
		}
		
		set {
			courseList[index] = newValue
		}
	}
}

extension CourseList : SequenceType {
	public typealias Generator = CourseListGenerator
	
	public func generate() -> Generator {
		return CourseListGenerator(courseList: self.courseList)
	}
}