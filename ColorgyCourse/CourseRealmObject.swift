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
	dynamic var dtStart: String = ""
	dynamic var dtEnd: String = ""
	dynamic var detailDescription: String?
	dynamic var referenceId: String?
	dynamic var createdAt: String = ""
	dynamic var updatedAt: String?
	
	dynamic var courseCredits: Int = 0
	dynamic var courseLecturer: String?
	dynamic var courseURL: String = ""
	dynamic var courseCode: String = ""
	dynamic var courseRequired: Bool = false
	dynamic var courseTerm: Int = 0
	dynamic var courseYear: Int = 0
	
	let subcourses = List<SubcourseRealmObject>()
	
	// MARK: - Init
	public init(withCourse: Course) {
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
	}
}
