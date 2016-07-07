//
//  SubcourseRealmObject.swift
//  ColorgyCourse
//
//  Created by David on 2016/7/4.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import RealmSwift

final public class SubcourseRealmObject: Object {
	
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var uuid: String =  ""
	dynamic var detailDescription: String?
	dynamic var rrule: RRuleRealmObject?
	dynamic var dtStart: NSDate = NSDate()
	dynamic var dtEnd: NSDate = NSDate()
	dynamic var createdAt: NSDate = NSDate()
	dynamic var updatedAt: NSDate?
	
	dynamic var courseCredits: Int = 0
	dynamic var courseLecturer: String?
	dynamic var courseURL: String = ""
	dynamic var courseCode: String = ""
	dynamic var courseRequired: Bool = false
	dynamic var courseTerm: Int = 0
	dynamic var courseYear: Int = 0
	
	// MARK: - Init
	public convenience init(withSubcourse subcourse: Subcourse) {
		self.init()
		self.id = subcourse.id
		self.name = subcourse.name
		self.uuid = subcourse.uuid
		self.rrule = subcourse.rrule?.toRealmObject
		self.dtStart = subcourse.dtStart
		self.dtEnd = subcourse.dtEnd
		self.detailDescription = subcourse.detailDescription
		self.createdAt = subcourse.createdAt
		self.updatedAt = subcourse.updatedAt
		self.courseCredits = subcourse.courseCredits
		self.courseLecturer = subcourse.courseLecturer
		self.courseURL = subcourse.courseURL
		self.courseCode = subcourse.courseCode
		self.courseRequired = subcourse.courseRequired
		self.courseTerm = subcourse.courseTerm
		self.courseYear = subcourse.courseYear
	}
}

extension SubcourseRealmObject {
	public class func generate(withSubcourses subcourses: [Subcourse]) -> [SubcourseRealmObject] {
		var objects = [SubcourseRealmObject]()
		for subcourse in subcourses {
			let object = SubcourseRealmObject(withSubcourse: subcourse)
			objects.append(object)
		}
		return objects
	}
}