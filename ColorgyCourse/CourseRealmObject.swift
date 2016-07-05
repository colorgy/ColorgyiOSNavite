//
//  CourseRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class CourseRealmObject: Object {
	
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var rrule: String?
	dynamic var dtStart: NSDate = NSDate()
	dynamic var dtEnd: NSDate = NSDate()
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
	dynamic var courseCredits: Int = 0
	dynamic var courseLecturer: String?
	dynamic var courseURL: String = ""
	dynamic var courseCode: String = ""
	dynamic var courseRequired: Bool = false
	dynamic var courseTerm: Int = 0
	dynamic var courseYear: Int = 0
	
	var subcourses = List<SubcourseRealmObject>()
	
	// MARK: - Init
	public convenience init(withCourse course: Course) {
		self.init()
		self.id = course.id
		self.name = course.name
		self.uuid = course.uuid
		self.rrule = course.rrule
		self.dtStart = course.dtStart
		self.dtEnd = course.dtEnd
		self.detailDescription = course.detailDescription
		self.referenceId = course.referenceId
		self.createdAt = course.createdAt
		self.updatedAt = course.updatedAt
		self.courseCredits = course.courseCredits
		self.courseLecturer = course.courseLecturer
		self.courseURL = course.courseURL
		self.courseCode = course.courseCode
		self.courseRequired = course.courseRequired
		self.courseTerm = course.courseTerm
		self.courseYear = course.courseYear
		
		let subcourseObjects = SubcourseRealmObject.generate(withSubcourses: course.subcourses)
		self.subcourses.appendContentsOf(subcourseObjects)
	}
	
}

extension Realm {
	public class func clearRealm() {
		do {
			let realm = try Realm()
			realm.beginWrite()
			realm.deleteAll()
			try realm.commitWrite()
		} catch {
			
		}
	}
}

extension CourseRealmObject {
	public class func getCourseList() -> CourseList? {
		do {
			let realm = try Realm()
			// get courses store in realm
			// cause its Results, so we need to map it and turn it into sequence type
			let courseObjects = realm.objects(CourseRealmObject.self).map { $0 }
			// init a list
			let courseList = CourseList()
			// tranform into Course
			let courses = Course.generateCourses(withRealmObjects: courseObjects)
			// add to list
			courseList.add(courses)
			// return list
			return courseList
		} catch {
			return nil
		}
	}
}
