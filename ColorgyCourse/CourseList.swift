//
//  CourseList.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class CourseList {
	public var courseList: [Course]
	
	public init() {
		courseList = [Course]()
	}
	
	public func add(course: Course) {
		courseList.append(course)
	}
	
	public func add(courses: [Course]) {
		courseList.appendContentsOf(courses)
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

extension CourseList : CustomStringConvertible {
	public var description: String {
		return courseList.description
	}
}

extension CourseList {
	public func saveListToRealm(complete: ((succeed: Bool) -> Void)?) {
		do {
			let realm = try Realm()
			realm.beginWrite()
			// start writing to realm
			self.forEach({ (course) in
				let courseRealmObject = CourseRealmObject(withCourse: course)
				realm.add(courseRealmObject)
			})
			// commit write
			try realm.commitWrite()
			// finished
			complete?(succeed: true)
		} catch {
			complete?(succeed: false)
		}
	}
}

extension CourseList : SequenceType {
	public typealias Generator = CourseListGenerator
	
	public func generate() -> Generator {
		return CourseListGenerator(courseList: self.courseList)
	}
}