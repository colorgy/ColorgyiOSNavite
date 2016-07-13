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
	dynamic var rrule: RRuleRealmObject?
	dynamic var startTime: NSDate = NSDate()
	dynamic var endTime: NSDate = NSDate()
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
		self.rrule = course.rrule?.toRealmObject
		self.startTime = course.startTime
		self.endTime = course.endTime
		self.detailDescription = course.detailDescription
		self.referenceId = course.referenceId
		self.createdAt = course.createdAt
		self.updatedAt = course.updatedAt
		self.courseCredits = course.courseCredits ?? 0
		self.courseLecturer = course.courseLecturer
		self.courseURL = course.courseURL ?? ""
		self.courseCode = course.courseCode ?? ""
		self.courseRequired = course.courseRequired
		self.courseTerm = course.courseTerm ?? 0
		self.courseYear = course.courseYear ?? 0
		
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
	
	public class func queryDate(fromDate fromDate: NSDate, toDate: NSDate, complete: ((objects: [CourseRealmObject]) -> Void)?) {
		guard fromDate.isBefore(toDate) else {
			complete?(objects: [])
			print(#function, "from date must smaller than to date")
			return
		}
		do {
			let realm = try Realm()
			let objects = realm.objects(CourseRealmObject.self).filter("rrule.dtStart <= %@ AND rrule.until >= %@", toDate, fromDate).map { $0 }
//			let objects = realm.objects(CourseRealmObject.self).filter("dtStart <= %@ AND dtEnd >= %@", toDate, fromDate).map { $0 }
			complete?(objects: objects)
		} catch {
			complete?(objects: [])
		}
	}
	
	public class func queryData(fromYear fromYear: Int, toYear: Int, complete: ((objects: [CourseRealmObject]) -> Void)?) {
		guard fromYear <= toYear else {
			complete?(objects: [])
			print(#function, "from year must smaller than to year")
			return
		}
		guard let fromDate = NSDate.create(dateOnYear: fromYear, month: 1, day: 1) else {
			complete?(objects: [])
			return
		}
		guard let toDate = NSDate.create(dateOnYear: toYear, month: 12, day: 31) else {
			complete?(objects: [])
			return
		}
		queryDate(fromDate: fromDate, toDate: toDate, complete: complete)
	}
	
	/// Get all stored objects of CourseRealmObject
	public class func getAllStoredObjects() -> [CourseRealmObject]? {
		do {
			let realm = try Realm()
			return realm.objects(CourseRealmObject.self).map { $0 }
		} catch {
			return nil
		}
	}
}

extension Array where Element: CourseRealmObject {
	public var toCoursesArray: [Course] {
		return Course.generateCourses(withRealmObjects: self)
	}
}
